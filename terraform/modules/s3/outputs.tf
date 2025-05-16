output "app_bucket_name" {
  value = aws_s3_bucket.app_bucket.id

}

output "log_bucket_name" {
  value = aws_s3_bucket.logs_bucket.id
}

output "oai_id" {
  value = aws_cloudfront_origin_access_identity.cloudfront_oai.id
}
