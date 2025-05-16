variable "environment" {
  type = string
}

variable "origin_bucket" {
  type = string
}

variable "log_bucket" {
  type = string
}

variable "origin_access_identity" {
  type = string
}



locals {
  cache_policy_id      = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  log_source_name      = "${var.environment}-cf-logs"
  log_destination_name = "${var.environment}-cf-logs-dest"
}


resource "aws_cloudfront_distribution" "cdn" {


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    origin_id   = "S3-${var.origin_bucket}"
    domain_name = "${var.origin_bucket}.s3.amazonaws.com"
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${var.origin_access_identity}"
    }
  }

  default_cache_behavior {
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = local.cache_policy_id
    compress               = true
    target_origin_id       = "S3-${var.origin_bucket}"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  enabled = true


  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0

  }

}


resource "aws_cloudwatch_log_delivery_source" "cf_logs_source" {
  name         = local.log_source_name
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.cdn.arn

}



resource "aws_cloudwatch_log_delivery_destination" "cf_logs_dest" {
  name          = local.log_destination_name
  output_format = "parquet"

  delivery_destination_configuration {
    destination_resource_arn = "arn:aws:s3:::${var.log_bucket}"
  }

}

resource "aws_cloudwatch_log_delivery" "cf_to_s3" {

  delivery_source_name     = aws_cloudwatch_log_delivery_source.cf_logs_source.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.cf_logs_dest.arn

}


