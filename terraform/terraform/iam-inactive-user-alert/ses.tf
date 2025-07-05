resource "aws_ses_email_identity" "sender" {
  email = "pauledukpe@yahoo.com"
}

resource "aws_iam_policy" "ses_send_email_policy" {
  name        = "SESInactiveUserSendPolicy"
  description = "Allows Lambda to send email via SES"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ses_policy" {
  role       = aws_iam_role.inactive_user_lambda_role.name
  policy_arn = aws_iam_policy.ses_send_email_policy.arn
}
