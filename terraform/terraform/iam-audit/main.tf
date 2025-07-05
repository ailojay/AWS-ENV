provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# S3 bucket to store audit reports
resource "aws_s3_bucket" "audit_bucket" {
  bucket = "iam-audit-logs-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "IAM Audit Logs Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "audit_block" {
  bucket = aws_s3_bucket.audit_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_encryption" {
  bucket = aws_s3_bucket.audit_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_audit_role" {
  name = "IAMAuditLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM policy for the Lambda
resource "aws_iam_role_policy" "lambda_audit_policy" {
  name = "IAMAuditPolicy"
  role = aws_iam_role.lambda_audit_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:ListUsers",
          "iam:ListMFADevices",
          "iam:ListAccessKeys"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.audit_bucket.bucket}/*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

output "audit_bucket_name" {
  value = aws_s3_bucket.audit_bucket.id
}

resource "aws_lambda_function" "iam_audit" {
  filename         = "function.zip"
  function_name    = "IAMUserAudit"
  role             = aws_iam_role.lambda_audit_role.arn
  handler          = "iam_audit.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("function.zip")
  timeout          = 15

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.audit_bucket.id
    }
  }
}

resource "aws_cloudwatch_event_rule" "weekly_audit" {
  name                = "WeeklyIAMAudit"
  schedule_expression = "rate(7 days)"
}

resource "aws_cloudwatch_event_target" "lambda_trigger" {
  rule      = aws_cloudwatch_event_rule.weekly_audit.name
  target_id = "LambdaAudit"
  arn       = aws_lambda_function.iam_audit.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_audit.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_audit.arn
}
