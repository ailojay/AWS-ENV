resource "aws_lambda_function" "iam_key_audit" {
  filename         = "${path.module}/function/lambda.zip"
  function_name    = "IAMUserAudit"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_audit_role.arn
  timeout       = 10


  environment {
    variables = {
      BUCKET_NAME     = aws_s3_bucket.audit_bucket.id
      SES_SENDER      = var.ses_sender_email
      SES_RECIPIENT   = var.ses_recipient_email
    }
  }
}
