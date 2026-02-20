output "api_id" {
  description = "ID of the HTTP API"
  value       = aws_apigatewayv2_api.http_api.id
}

output "api_endpoint" {
  description = "Base invoke URL of the API (without stage)"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "stage_invoke_url" {
  description = "Full invoke URL including the $default stage"
  value       = "${aws_apigatewayv2_api.http_api.api_endpoint}/"
}