output "lambda_arns" {
  description = "Map of job name → Lambda ARN"
  value = {
    for k, fn in aws_lambda_function.this : k => fn.arn
  }
}

output "function_names" {
  description = "Map of job name → Lambda function name"
  value = {
    for k, fn in aws_lambda_function.this : k => fn.function_name
  }
}

output "invoke_arns" {
  description = "Map of job name → Lambda invoke ARN"
  value = {
    for k, fn in aws_lambda_function.this : k => fn.invoke_arn
  }
}