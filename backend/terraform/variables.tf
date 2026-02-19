variable "region" {
  type    = string
  default = "us-east-1"
}

variable "service_name" {
  type    = string
  default = "pnmac-project-backend-tf"
}

variable "table_name" {
  type    = string
  default = "ticker-winner-tf"
}

variable "secret_name" {
  type    = string
  default = "pnmac-project"
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

#variable "movers_zip_path" {
#  type    = string
#  default = "../dist/movers.zip"
#}

