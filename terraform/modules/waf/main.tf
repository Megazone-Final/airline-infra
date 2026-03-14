locals {
  cloudfront_name        = join("-", ["waf", var.region_code, var.project_name, "cf", "main"])
  cloudfront_metric_name = join("-", ["waf", var.region_code, var.project_name, "cf", "main"])
  iprep_metric_name      = join("-", ["waf", var.region_code, var.project_name, "cf", "iprep"])
  common_metric_name     = join("-", ["waf", var.region_code, var.project_name, "cf", "common"])
  knownbad_metric_name   = join("-", ["waf", var.region_code, var.project_name, "cf", "knownbad"])
  sqli_metric_name       = join("-", ["waf", var.region_code, var.project_name, "cf", "sqli"])
}

resource "aws_wafv2_web_acl" "cloudfront" {
  count = var.enabled ? 1 : 0

  name  = local.cloudfront_name
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  # Amazon 위협 인텔리전스 기반의 악성 IP 평판 목록을 차단합니다.
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = local.iprep_metric_name
      sampled_requests_enabled   = true
    }
  }

  # OWASP Top 10 계열을 포함한 일반적인 웹 공격 패턴을 차단합니다.
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = local.common_metric_name
      sampled_requests_enabled   = true
    }
  }

  # 알려진 악성 입력값 및 비정상 요청 패턴을 차단합니다.
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = local.knownbad_metric_name
      sampled_requests_enabled   = true
    }
  }

  # SQL Injection 시도를 탐지하고 차단합니다.
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = local.sqli_metric_name
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.cloudfront_metric_name
    sampled_requests_enabled   = true
  }

  tags = merge(var.tags, {
    Name = local.cloudfront_name
  })
}
