variable "environment" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "log_bucket_name" {
  type = string
}


// APPLICATION BUCKET


resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name
}


resource "aws_s3_bucket_ownership_controls" "app_bucket_ownership" {

  bucket = aws_s3_bucket.app_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "app_public_access" {
  bucket                  = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_acl" "app_bucket_acl" {

  depends_on = [aws_s3_bucket_ownership_controls.app_bucket_ownership, aws_s3_bucket_public_access_block.app_public_access]

  bucket = aws_s3_bucket.app_bucket.id
  acl    = "private"



}

resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
}


resource "aws_s3_bucket_policy" "app_bucket_policy" {

  bucket = aws_s3_bucket.app_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.app_bucket.id}/*"
      }
    ]
  })

}


// LOGS BUCKET


resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.log_bucket_name
}



resource "aws_s3_bucket_ownership_controls" "logs_ownership" {

  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "logs_public_access" {
  bucket                  = aws_s3_bucket.logs_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



resource "aws_s3_bucket_acl" "logs_bucket_acl" {

  depends_on = [aws_s3_bucket_ownership_controls.logs_ownership, aws_s3_bucket_public_access_block.logs_public_access]

  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "log-delivery-write"



}





