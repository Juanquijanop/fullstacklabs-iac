output "app_bucket" {
  value = module.s3.app_bucket_name
}

output "logs_bucket" {
  value = module.s3.log_bucket_name
}

output "oai_id" {
  value = module.s3.oai_id
}

output "cloudfront_domain" {
  value = module.cloudfront.cnd_domain
}

output "cloudfront_id" {
  value = module.cloudfront.distribution_id
}