
output "deny_policy_arns" {
  value = {
    "tlz_deny_kmsdelete"            = "${aws_iam_policy.tlz_deny_kmsdelete.arn}"
    "tlz_deny_billing"              = "${aws_iam_policy.tlz_deny_billing.arn}"
    "tlz_deny_unauthorized_regions" = "${aws_iam_policy.tlz_deny_unauthorized_regions.arn}"
    "tlz_deny_marketplace_access"   = "${aws_iam_policy.tlz_deny_marketplace_access.arn}"
    "tlz_deny_iam_delete"           = "${aws_iam_policy.tlz_deny_iam_delete.arn}"
    "tlz_deny_guard_duty"           = "${aws_iam_policy.tlz_deny_guard_duty.arn}"
    "tlz_deny_route53_domains"      = "${aws_iam_policy.tlz_deny_route53_domains.arn}"
    "tlz_deny_vpc_peering"          = "${aws_iam_policy.tlz_deny_vpc_peering.arn}"
    "tlz_deny_external_networking"  = "${aws_iam_policy.tlz_deny_external_networking.arn}"
  }
}
