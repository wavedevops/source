provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "chowdary-hari"
    key    = "iam/iam/terraform.tfstate"
    region = "us-east-1"
  }
}
