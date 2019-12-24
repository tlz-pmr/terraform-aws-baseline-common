# output "account_alias" {
#   description = "Account alias"
#   value       = "${aws_iam_account_alias.alias}"
# }

output "baseline_version" {
  description = "Version of the baseline module"
  value       = "${local.baseline_version}"
}

output "okta_provider_arn" {
  description = "okta_provider_arn"
  value = "${aws_iam_saml_provider.okta.arn}"
}

output "deny_policy_arns" {
  value = "${
    map(
      "tlz_deny_kmsdelete", "${module.iam-policy.deny_policy_arns["tlz_deny_kmsdelete"]}",
      "tlz_deny_billing", "${module.iam-policy.deny_policy_arns["tlz_deny_billing"]}",
      "tlz_deny_unauthorized_regions", "${module.iam-policy.deny_policy_arns["tlz_deny_unauthorized_regions"]}",
      "tlz_deny_marketplace_access", "${module.iam-policy.deny_policy_arns["tlz_deny_marketplace_access"]}",
      "tlz_deny_iam_delete", "${module.iam-policy.deny_policy_arns["tlz_deny_iam_delete"]}",
      "tlz_deny_guard_duty", "${module.iam-policy.deny_policy_arns["tlz_deny_guard_duty"]}",
      "tlz_deny_route53_domains", "${module.iam-policy.deny_policy_arns["tlz_deny_route53_domains"]}",
      "tlz_deny_vpc_peering", "${module.iam-policy.deny_policy_arns["tlz_deny_vpc_peering"]}",
      "tlz_deny_external_networking", "${module.iam-policy.deny_policy_arns["tlz_deny_external_networking"]}"
    )
  }"
}
