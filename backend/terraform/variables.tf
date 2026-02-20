variable "region" {
  type    = string
  default = "us-east-1"
}

variable "service_name" {
  type    = string
  default = "pnmac-stocks-project"
}

variable "secret_name" {
  type    = string
  default = "pnmac_project"
}

variable "massive_api_key_name" {
  type    = string
  default = "MASSIVE_API_KEY"
}

# Paths to your zipped Lambda artifacts
variable "cron_zip_path" {
  type    = string
  default = "../dist/cron.zip"
}

variable "api_zip_path" {
  type    = string
  default = "../dist/api.zip"
}


