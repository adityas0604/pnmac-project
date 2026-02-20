module "s3" {
  source = "./modules/s3-static-bucket"

  bucket_name                  = var.bucket_name
  cloudfront_distribution_arn = module.cloudfront.distribution_arn   
}

module "cloudfront" {
  source = "./modules/cloudfront"

  project_name            = var.project_name
  s3_origin_domain_name   = module.s3.bucket_regional_domain_name
  s3_origin_bucket_id     = module.s3.bucket_id

}