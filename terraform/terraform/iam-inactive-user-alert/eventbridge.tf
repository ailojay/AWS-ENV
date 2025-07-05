resource "aws_cloudwatch_event_rule" "daily_inactive_user_audit" {
  name                = "DailyInactiveUserAudit"
  description         = "Trigger Lambda function daily to check for inactive IAM users"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.daily_inactive_user_audit.name
  arn       = aws_lambda_function.iam_audit.arn
  target_id = "InvokeInactiveUserAuditLambda"
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_audit.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_inactive_user_audit.arn
}
