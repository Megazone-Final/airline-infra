# 환경 파일은 모듈 호출만 유지하고,
# CloudFront 범위 WAF에 필요한 us-east-1 provider를 모듈로 전달합니다.
module "waf_cloudfront" {
  source = "../../modules/waf"

  providers = {
    aws = aws.us_east_1
  }

  enabled      = var.waf_cloudfront_enabled
  region_code  = var.region_code
  project_name = var.project_name
  tags         = local.common_tags
}
