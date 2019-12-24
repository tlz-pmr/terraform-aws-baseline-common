output "tlz_admin_role_arn" {
  description = "tlz_admin role arn"
  value = "${aws_iam_role.tlz_admin.arn}"
}

output "tlz_admin_role_id" {
  description = "tlz_admin role id"
  value = "${aws_iam_role.tlz_admin.id}"
}

output "tlz_admin_role_name" {
  description = "tlz_admin role name"
  value = "${aws_iam_role.tlz_admin.name}"
}
