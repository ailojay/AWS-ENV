resource "aws_cloudwatch_event_rule" "weekly_audit" {
  name                = "WeeklyIAMAccessKeyAudit"
  schedule_expression = "rate(7 days)"
}

resource "aws_cloudwatch_event_target" "lambda_trigger" {
  rule      = aws_cloudwatch_event_rule.weekly_audit.name
  target_id = "IAMKeyAuditTarget"
  arn       = aws_lambda_function.iam_key_audit.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch-${random_id.suffix.hex}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_key_audit.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_audit.arn
}
