provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  tags = {
    Service = var.service_name
  }
}

resource "aws_dynamodb_table" "ticker_winner" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "Date"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }

  tags = local.tags
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.service_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = local.tags
}



resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



#----
# IAM SeUp
#----
resource "aws_iam_policy" "lambda_app_policy" {
name = "${var.service_name}-lambda-app-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.ticker_winner.arn
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        # Equivalent to: arn:aws:secretsmanager:${region}:${account}:secret:pnmac_project-*
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:pnmac_project-*"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "lambda_app_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_app_policy.arn
}

#----
# CRON Jobs Setup
#----

resource "aws_lambda_function" "cron" {
  for_each = var.cron_jobs

  function_name = "${var.service_name}-${each.key}"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs20.x"
  handler       = each.value.handler
  timeout       = each.value.timeout
  memory_size   = each.value.memory_size

  filename         = var.cron_zip_path   # same zip for all cron lambdas
  source_code_hash = filebase64sha256(var.cron_zip_path)

  environment {
    variables = {
      SECRET_NAME          = var.secret_name
      MASSIVE_API_KEY_NAME = var.massive_api_key_name
      JOB_NAME             = each.key
    }
  }

  tags = local.tags
}


resource "aws_cloudwatch_event_target" "cron" {
  for_each = var.cron_jobs

  rule      = aws_cloudwatch_event_rule.cron[each.key].name
  target_id = each.key
  arn       = aws_lambda_function.cron[each.key].arn
}

resource "aws_cloudwatch_event_rule" "cron" {
  for_each = var.cron_jobs

  name                = "${var.service_name}-${each.key}-rule"
  schedule_expression = each.value.schedule
  tags                = local.tags
}

resource "aws_lambda_permission" "allow_eventbridge" {
  for_each = var.cron_jobs

  statement_id  = "AllowExecutionFromEventBridge-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cron[each.key].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron[each.key].arn
}

#----
# API Routes Setup
#----

resource "aws_apigatewayv2_api" "http_api" {
  name          = var.service_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["*"]
  }

  tags = local.tags
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_function" "api" {
  for_each = var.api_routes

  function_name = "${var.service_name}-api-${each.key}"
  role          = aws_iam_role.lambda_role.arn
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

  tags = local.tags
}

resource "aws_apigatewayv2_integration" "api" {
  for_each = var.api_routes

  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api[each.key].invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "api" {
  for_each = var.api_routes

  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.api[each.key].id}"
}

resource "aws_lambda_permission" "allow_apigw_invoke_api" {
  for_each = var.api_routes

  statement_id  = "AllowExecutionFromAPIGateway-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}














