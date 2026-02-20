output "invoke_arns" {
  value = {
    for k, lambda in aws_lambda_function.this : k => lambda.invoke_arn
  }
}

output "function_names" {
  value = {
    for k, lambda in aws_lambda_function.this : k => lambda.function_name
  }
}