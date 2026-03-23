locals {
  cloudfront_name        = join("-", ["waf", var.region_code, var.project_name, "cloudfront"])
  cloudfront_metric_name = join("-", ["waf", var.region_code, var.project_name, "cloudfront"])
  iprep_metric_name      = join("-", ["waf", var.region_code, var.project_name, "cloudfront-iprep"])
  common_metric_name     = join("-", ["waf", var.region_code, var.project_name, "cloudfront-common"])
  knownbad_metric_name   = join("-", ["waf", var.region_code, var.project_name, "cloudfront-knownbad"])
  sqli_metric_name       = join("-", ["waf", var.region_code, var.project_name, "cloudfront-sqli"])
  admin_metric_name      = join("-", ["waf", var.region_code, var.project_name, "admin", "allow"])

  normalized_admin_host       = lower(trimspace(var.admin_host))
  admin_protection_configured = var.admin_protection_enabled && local.normalized_admin_host != "" && length(var.admin_allowed_ip_cidrs) > 0
}

resource "aws_wafv2_ip_set" "admin_allowed" {
  count = local.admin_protection_configured ? 1 : 0

  name               = join("-", ["ipset", var.region_code, var.project_name, "admin", "allow"])
  description        = "Allowed client IP ranges for admin host access"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.admin_allowed_ip_cidrs

  tags = merge(var.tags, {
    Name = join("-", ["ipset", var.region_code, var.project_name, "admin", "allow"])
  })
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

  dynamic "rule" {
    for_each = local.admin_protection_configured ? [1] : []

    content {
      # admin 호스트로 들어오는 요청은 허용된 IP 대역에서만 접근할 수 있게 제한합니다.
      name     = "AdminHostAllowlist"
      priority = 5

      action {
        block {}
      }

      statement {
        and_statement {
          statement {
            byte_match_statement {
              field_to_match {
                single_header {
                  name = "host"
                }
              }

              positional_constraint = "EXACTLY"
              search_string         = local.normalized_admin_host

              text_transformation {
                priority = 0
                type     = "LOWERCASE"
              }
            }
          }

          statement {
            not_statement {
              statement {
                ip_set_reference_statement {
                  arn = aws_wafv2_ip_set.admin_allowed[0].arn
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = local.admin_metric_name
        sampled_requests_enabled   = true
      }
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
