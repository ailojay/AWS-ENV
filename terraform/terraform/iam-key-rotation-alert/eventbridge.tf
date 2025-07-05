resource "aws_cloudwatch_event_rule" "daily_iam_audit" {
  name                = "DailyIAMAccessKeyAudit"
  description         = "Triggers IAM audit Lambda function every 24 hours"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_trigger" {
  rule      = aws_cloudwatch_event_rule.daily_iam_audit.name
  target_id = "InvokeIAMAuditLambda"
  arn       = aws_lambda_function.iam_audit.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_audit.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_iam_audit.arn
}
