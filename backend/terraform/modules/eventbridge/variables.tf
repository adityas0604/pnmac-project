variable "service_name" {
    type        = string
    description = "Name of the service (used to prefix EventBridge rule names)"
  }
  
  variable "cron_jobs" {
    type = map(object({
      schedule = string
    }))
    description = "Map of cron job identifiers to their configuration (at minimum: schedule expression)"
  }
  
  variable "lambda_arns" {
    type = map(string)
    description = "Map of cron job key → corresponding Lambda function ARN (from lambda-cron module output)"
  }
  
  variable "lambda_function_names" {
    type = map(string)
    description = "Map of cron job key → corresponding Lambda function name (used in lambda permissions)"
  }
  
  variable "tags" {
    type        = map(string)
    default     = {}
    description = "Tags to apply to all EventBridge rules"
  }