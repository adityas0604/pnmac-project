output "rule_arns" {
  description = "Map of job key to EventBridge rule ARN"
  value = {
    for k, rule in aws_cloudwatch_event_rule.this : k => rule.arn
  }
}

output "rule_names" {
  value = {
    for k, rule in aws_cloudwatch_event_rule.this : k => rule.name
  }
}