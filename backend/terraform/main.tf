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

# Basic logging to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

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









