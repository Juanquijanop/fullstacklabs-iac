terraform {
  backend "s3" {
    bucket  = var.terraform_state_bucket
    key     = "${var.environment}/terraform.tfstate"
    region  = var.aws_region
    encrypt = true
  }
}