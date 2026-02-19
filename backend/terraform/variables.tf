variable "region" {
  type    = string
  default = "us-east-1"
}

variable "service_name" {
  type    = string
  default = "pnmac-project-backend"
}

variable "table_name" {
  type    = string
  default = "ticker-winner"
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
variable "ingest_zip_path" {
  type    = string
  default = "../dist/ingestDailyWinner.zip"
}

variable "movers_zip_path" {
  type    = string
  default = "../dist/movers.zip"
}

# CRON expression for the ingest daily winner lambda
variable "ingest_cron_expression" {
  type    = string
  default = "cron(10 5 ? * TUE-SAT *)"
}
