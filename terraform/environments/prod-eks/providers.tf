provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "prod"
      Team        = "Indiana Zones"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
