variable "service_name" {
  type = string
}

variable "api_routes" {
  type = map(object({
    handler     = string
    timeout     = number
    memory_size = number
    route_key   = string   
  }))
}

variable "role_arn" {
  type = string
}

variable "api_zip_path" {
  type = string
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