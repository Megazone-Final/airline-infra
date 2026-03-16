provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Environment = "prod"
      Team        = "Indiana Zones"
    }
  }
}

# CloudFront 범위 리소스(WAFv2 등)는 us-east-1 provider로 관리해야 하기에 선언
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "prod"
      Team        = "Indiana Zones"
    }
  }
}
