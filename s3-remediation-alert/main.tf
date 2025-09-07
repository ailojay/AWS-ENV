resource "aws_sns_topic" "remediation" {
  name = "s3-remediation-alerts"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.remediation.arn
  protocol  = "email"
  endpoint  = var.notification_email
}


resource "aws_iam_role" "lambda_remediation_role" {
  name = "RemediationLambdaRoleV2"


  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "lambda_permissions" {
  name = "lambda-inline-permissions"
  role = aws_iam_role.lambda_remediation_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketTagging"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "sns:Publish",
        Resource = aws_sns_topic.remediation.arn
      },
      {
  Effect = "Allow",
  Action = [
    "securityhub:BatchUpdateFindings"
  ],
  Resource = "*"
}

    ]
  })
}


resource "aws_lambda_function" "s3_remediation_lambda" {
  function_name = "s3-remediation-lambda"
  role          = aws_iam_role.lambda_remediation_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 10

  filename         = "${path.module}/lambda_src/function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_src/function.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.remediation.arn
      S3_LOG_BUCKET = var.log_bucket_name
    }
  }

  depends_on = [aws_iam_role_policy.lambda_permissions]
}



