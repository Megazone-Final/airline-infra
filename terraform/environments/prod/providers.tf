provider "aws" {
  region = "ap-northeast-2"

  default_tags {
  tags = {
    Environment = "prod"
    Team      = "Indiana Zones"
    }
  }
}

