resource "aws_waf_ipset" "ipset" {
  name = "${var.organization}-${var.env}-ip-somewhere-in-china"

  ip_set_descriptors {
    type  = "IPV4"
    value = "1.80.0.0/16"
  }
}

resource "aws_waf_rule" "wafrule" {
  depends_on = [
  aws_waf_ipset.ipset]
  name        = "${var.organization}-${var.env}-ip-somewhere-in-china"
  metric_name = "wafRuleIpSomewhereInChina"



  predicates {
    data_id = aws_waf_ipset.ipset.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "waf_acl" {
  depends_on = [
    aws_waf_ipset.ipset,
  aws_waf_rule.wafrule]
  name        = "${var.organization}-${var.env}-rouge-ip-adresses"
  metric_name = "wafAclIpSomewhereInChina"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_waf_rule.wafrule.id
    type     = "REGULAR"
  }
}
