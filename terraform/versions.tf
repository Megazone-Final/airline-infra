terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.24.0, < 7.0.0"
    }
  }

  backend "s3" {
    bucket  = "s3-an2-airline-infra"
    key     = "network/vpc/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
