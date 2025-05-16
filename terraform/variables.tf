variable "environment" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type = string
}

variable "log_bucket_name" {
  type = string
}

variable "terraform_state_bucket" {
  type = string
}