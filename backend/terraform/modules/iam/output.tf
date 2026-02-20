output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "ARN of the shared Lambda execution role"
}