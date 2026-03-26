terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.24.0, < 7.0.0"
    }
  }

  backend "s3" {
    bucket       = "s3-an2-airline-tfstate-036333380579-ap-northeast-2-an"
    key          = "prod-vpc/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
    kms_key_id   = "arn:aws:kms:ap-northeast-2:036333380579:key/40c16cfc-d284-4f40-a5ed-368bf54022a3"
  }
}
