resource "aws_ses_email_identity" "sender" {
  email = var.sender_email
}

resource "aws_iam_policy" "ses_send_email_policy" {
  name        = "SESSendEmailPolicy"
  description = "Allow Lambda to send emails using SES"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}
