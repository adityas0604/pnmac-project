# ─────────────────
# S3 Bucket 
# ──────────────────

output "s3_bucket_name" {
  description = "Name (ID) of the created S3 bucket"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "Full ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the bucket (used as CloudFront origin)"
  value       = module.s3.bucket_regional_domain_name
}

# ─────────────
# CloudFront 
# ─────────────

output "cloudfront_distribution_id" {
  description = "The identifier (ID) of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = module.cloudfront.distribution_arn
}

output "cloudfront_domain_name" {
  description = "The domain name / hostname of the CloudFront distribution"
  value       = module.cloudfront.domain_name
}

# ───────────────────────────────
# Website URL
# ────────────────────────────────

output "website_url" {
  description = "Public HTTPS URL of the static website (via CloudFront)"
  value       = "https://${module.cloudfront.domain_name}"
}

