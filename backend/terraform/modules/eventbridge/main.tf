resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.cron_jobs

  name                = "${var.service_name}-${each.key}-rule"
  schedule_expression = each.value.schedule
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.cron_jobs

  rule      = aws_cloudwatch_event_rule.this[each.key].name
  target_id = each.key
  arn       = var.lambda_arns[each.key]
}

resource "aws_lambda_permission" "allow_eventbridge" {
  for_each = var.cron_jobs

  statement_id  = "AllowExecutionFromEventBridge-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_names[each.key]
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this[each.key].arn
}