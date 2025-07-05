resource "aws_iam_role" "lambda_audit_role" {
  name = "IAMAuditLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

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
          "iam:ListAccessKeys"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.audit_bucket.arn}/*"
      },
      {
        Effect = "Allow",
        Action = "ses:SendEmail",
        Resource = "*"
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
