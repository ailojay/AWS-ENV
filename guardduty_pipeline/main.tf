variable "bucket_name" {
  description = "The base name for the S3 bucket"
  type        = string
  default     = "crypto-sec-findings"
}

variable "management_account_id" {
  description = "The AWS account ID of the management account"
  type        = string
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

data "aws_guardduty_detector" "main" {}

# resource "aws_securityhub_account" "main" {}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "crypto_findings" {
  bucket = "${var.bucket_name}-${substr(data.aws_caller_identity.current.account_id, -8, 8)}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty_findings_encryption" {
  bucket = aws_s3_bucket.crypto_findings.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "guardduty-lambda-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "guardduty-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = "arn:aws:iam::${var.management_account_id}:role/EC2TerminationRole"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:TerminateInstances",
          "ec2:ModifyInstanceAttribute"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "ses:SendEmail"
        Resource = "arn:aws:ses:${var.region}:${data.aws_caller_identity.current.account_id}:identity/${var.ses_email_source}"
        Condition = {
          StringEquals = {
            "ses:FromAddress" = var.ses_email_source
          }
        }
      },
      {
        Effect = "Allow"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.crypto_findings.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "guardduty_remediation" {
  filename      = "lambda_function.zip"
  function_name = "guardduty-crypto-remediation-${random_string.suffix.result}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10

  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      SES_EMAIL_SOURCE    = var.ses_email_source
      SES_EMAIL_RECIPIENT = var.ses_email_recipient
      S3_BUCKET_PREFIX    = var.s3_bucket_prefix
      MANAGEMENT_ACCOUNT_ID = var.management_account_id
    }
  }
}

resource "aws_cloudwatch_event_rule" "guardduty_rule" {
  name        = "guardduty-crypto-rule-${random_string.suffix.result}"
  description = "Triggers on GuardDuty crypto mining findings"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
    detail = {
      type = ["CryptoCurrency:EC2/BitcoinTool.B"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_rule.name
  target_id = "GuardDutyLambda"
  arn       = aws_lambda_function.guardduty_remediation.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardduty_remediation.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.guardduty_rule.arn
}

resource "aws_ses_email_identity" "notification_email" {
  email = var.ses_email_source
}