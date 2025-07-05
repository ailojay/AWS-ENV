resource "aws_iam_role" "lambda_exec_role" {
  name = "IAMAccessKeyAuditLambdaRole"
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

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_ses_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.ses_send_email_policy.arn
}

resource "aws_lambda_function" "iam_audit" {
  function_name = "IAMAccessKeyAudit"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "lambda/iam_audit.zip"
  source_code_hash = filebase64sha256("lambda/iam_audit.zip")
  timeout       = 30

  environment {
    variables = {
      SENDER_EMAIL = var.sender_email
    }
  }
}
