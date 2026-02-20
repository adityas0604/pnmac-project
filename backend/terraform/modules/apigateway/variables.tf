variable "service_name" {
  type        = string
  description = "Name of the service (used for API name and tags)"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
}

variable "routes" {
  type = map(object({
    route_key   = string
    invoke_arn  = string
    function_name = string
  }))
  description = "Map of route identifiers to { route_key, lambda invoke ARN , function_name }"
}