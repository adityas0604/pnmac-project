# ─────────────────────
# Database
# ──────────────────────

output "dynamodb_table_name" {
  description = "Name of the main DynamoDB table"
  value       = module.dynamodb.table_name
}


# ────────────────────
# API Gateway 
# ─────────────────────

output "api_invoke_url" {
  description = "Full base URL to invoke the HTTP API (append your route paths)"
  value       = module.apigateway.stage_invoke_url
}

output "api_endpoint_base" {
  description = "Base domain of the API Gateway (without stage)"
  value       = module.apigateway.api_endpoint
}

# ───────────────
# Lambda 
# ───────────────

output "api_lambda_function_names" {
  description = "Map of API route key to Lambda function name"
  value       = module.lambda_api.function_names
}

output "cron_lambda_function_names" {
  description = "Map of cron job name to Lambda function name"
  value       = module.lambda_cron.function_names
}


