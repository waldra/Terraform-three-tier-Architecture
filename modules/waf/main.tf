terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

resource "aws_wafv2_web_acl" "waf_acl" {
  #provider    = aws.global
  name        = var.waf_name
  scope       = "CLOUDFRONT"
  description = "WAF ACL to protect against XSS and SQL Injection"

  default_action {
    allow {}
  }

  rule {
    name     = "XSS-and-SQL-Injection-Rule"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "XSSandSQLProtection"
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "WAFACLVisibilityMetric"
  }
}

