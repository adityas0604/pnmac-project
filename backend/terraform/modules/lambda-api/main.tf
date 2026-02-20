resource "aws_lambda_function" "this" {
  for_each = var.api_routes

  function_name = "${var.service_name}-api-${each.key}"
  role          = var.role_arn
  runtime       = "nodejs20.x"
  handler       = each.value.handler
  timeout       = each.value.timeout
  memory_size   = each.value.memory_size

  filename         = var.api_zip_path
  source_code_hash = filebase64sha256(var.api_zip_path)

  environment {
    variables = {
      SECRET_NAME          = var.secret_name
      MASSIVE_API_KEY_NAME = var.massive_api_key_name
    }
  }

  tags = var.tags
}