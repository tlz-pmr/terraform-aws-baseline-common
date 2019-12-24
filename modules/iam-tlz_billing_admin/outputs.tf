output "tlz_billing_admin_role_arn" {
  description = "tlz_billing_admin role arn"
  value = "${aws_iam_role.tlz_billing_admin.*.arn}"
}

output "tlz_billing_admin_role_id" {
  description = "tlz_billing_admin role id"
  value = "${aws_iam_role.tlz_billing_admin.*.id}"
}

output "tlz_billing_admin_role_name" {
  description = "tlz_billing_admin role name"
  value = "${aws_iam_role.tlz_billing_admin.*.name}"
}
