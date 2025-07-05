resource "aws_lambda_function" "iam_audit" {
  function_name    = "InactiveUserAudit"
  filename         = "lambda.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.inactive_user_lambda_role.arn
  timeout          = 10
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      SES_SENDER    = var.ses_sender_email
      SES_RECIPIENT = var.ses_recipient_email
    }
  }
}
