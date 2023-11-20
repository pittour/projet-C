resource "aws_wafv2_web_acl" "waf" {
  name = "${var.user}-${var.site}-wacl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name = "AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true 
    metric_name = "webACLVisibilityConfig"
    sampled_requests_enabled = true 
  }

  tags = {
    Name = "${var.user}-${var.site}-wacl"
  }
}

resource "aws_wafv2_web_acl_association" "waf-alb" {
  resource_arn = aws_lb.lb.arn
  web_acl_arn = aws_wafv2_web_acl.waf.arn
}