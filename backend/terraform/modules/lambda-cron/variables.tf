variable "service_name" {
  type        = string
  description = "Base name for resources"
}

variable "cron_jobs" {
  type = map(object({
    handler     = string
    timeout     = number
    memory_size = number
    schedule    = string  
  }))
  description = "Map of cron job names to their configuration"
}

variable "role_arn" {
  type        = string
  description = "ARN of the shared Lambda execution role"
}

variable "cron_zip_path" {
  type        = string
  description = "Path to the zipped code package (same for all cron Lambdas)"
}

variable "secret_name" {
  type = string
}

variable "massive_api_key_name" {
  type = string
}

variable "tags" {
  type = map(string)
}