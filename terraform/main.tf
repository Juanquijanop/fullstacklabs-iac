provider "aws" {
  region = var.aws_region
}

module "s3" {
  source          = "./modules/s3"
  environment     = var.environment
  bucket_name     = var.bucket_name
  log_bucket_name = var.log_bucket_name
}

module "cloudfront" {
  source                 = "./modules/cloudfront"
  environment            = var.environment
  origin_bucket          = module.s3.app_bucket_name
  log_bucket             = module.s3.log_bucket_name
  origin_access_identity = module.s3.oai_id

  depends_on = [module.s3]

}