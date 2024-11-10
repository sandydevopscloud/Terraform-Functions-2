provider "aws" {
  region = var.region_name
}

terraform {
  backend "s3" {
    bucket = "aws-terra-s3"
    key    = "workspace-terra"
    region = "eu-north-1"
  }
}
