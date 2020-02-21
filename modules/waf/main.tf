//resource "aws_waf_web_acl" "waf_acl" {
//  depends_on  = ["aws_waf_ipset.ipset", "aws_waf_rule.wafrule"]
//  name        = "tfWebACL"
//  metric_name = "tfWebACL"
//
//  default_action {
//    type = "ALLOW"
//  }
//
//  rules {
//    action {
//      type = "BLOCK"
//    }
//
//    priority = 1
//    rule_id  = "${aws_waf_rule.wafrule.id}"
//    type     = "REGULAR"
//  }
//}