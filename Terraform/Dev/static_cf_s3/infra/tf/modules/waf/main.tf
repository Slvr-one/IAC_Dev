resource "aws_wafv2_web_acl" "static" {
  name  = "static-web-acl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "static-rule"
    priority = 1

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = ["US", "CA"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "staticRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "staticWebAcl"
    sampled_requests_enabled   = true
  }
}
