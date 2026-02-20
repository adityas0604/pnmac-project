locals {
  tags = {
    Service = var.service_name
  }
  api_routes = yamldecode(file("api-routes.yaml"))
  cron_jobs = yamldecode(file("cron.yaml"))
}

#----
# DynamoDB Setup
#----

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name =  "ticker-winner"
  tags       = local.tags
}

#----
# IAM Setup
#----

module "iam" {
  source = "./modules/iam"

  service_name = var.service_name
  tags       = local.tags
  table_arn  = module.dynamodb.table_arn
  region     = var.region
  account_id = data.aws_caller_identity.current.account_id
  secret_name = var.secret_name
}

#----
# CRON Jobs Setup
#----

module "lambda_cron" {
  source = "./modules/lambda-cron"

  service_name         = var.service_name
  cron_jobs            = local.cron_jobs
  role_arn             = module.iam.lambda_role_arn
  cron_zip_path        = var.cron_zip_path
  secret_name          = var.secret_name
  massive_api_key_name = var.massive_api_key_name
  tags                 = local.tags
}


module "eventbridge" {
  source = "./modules/eventbridge"

  service_name           = var.service_name
  cron_jobs              = local.cron_jobs
  lambda_arns            = module.lambda_cron.lambda_arns
  lambda_function_names  = module.lambda_cron.function_names
  tags                   = local.tags
}

#----
# API Routes Setup
#----

module "lambda_api" {
  source = "./modules/lambda-api"

  service_name         = var.service_name
  api_routes           = local.api_routes
  role_arn             = module.iam.lambda_role_arn
  api_zip_path         = var.api_zip_path
  secret_name          = var.secret_name
  massive_api_key_name = var.massive_api_key_name
  tags                 = local.tags
}

module "apigateway" {
  source = "./modules/apigateway"

  service_name = var.service_name
  tags         = local.tags

  routes = {
    for key, route in local.api_routes : key => {
      route_key  = route.route_key
      invoke_arn = module.lambda_api.invoke_arns[key]
      function_name = module.lambda_api.function_names[key]
    }
  }
}
