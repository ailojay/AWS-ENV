resource "aws_iam_role" "inactive_user_lambda_role" {
  name = "InactiveUserAuditLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "inactive_user_policy" {
  name        = "InactiveUserAuditPolicy"
  description = "Allows Lambda to list IAM users and access keys"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:ListUsers",
          "iam:ListAccessKeys",
          "iam:GetUser",
          "iam:ListUserPolicies"
        ],
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

resource "aws_iam_role_policy_attachment" "attach_inactive_user_policy" {
  role       = aws_iam_role.inactive_user_lambda_role.name
  policy_arn = aws_iam_policy.inactive_user_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_lambda_basic_execution" {
  role       = aws_iam_role.inactive_user_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
