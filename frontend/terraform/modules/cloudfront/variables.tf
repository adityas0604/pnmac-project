variable "project_name" {
  type        = string
  description = "Project name used in resource names"
}

variable "s3_origin_domain_name" {
  type        = string
  description = "S3 bucket regional domain name (bucket.s3.region.amazonaws.com)"
}

variable "s3_origin_bucket_id" {
  type        = string
  description = "S3 bucket name / id (used in origin_id)"
}