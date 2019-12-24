output "tlz_developer_ro_role_arn" {
  description = "tlz_developer_ro role arn"
  value = "${aws_iam_role.tlz_developer_ro.arn}"
}

output "tlz_developer_ro_role_id" {
  description = "tlz_developer_ro role id"
  value = "${aws_iam_role.tlz_developer_ro.id}"
}

output "tlz_developer_ro_role_name" {
  description = "tlz_developer_ro role name"
  value = "${aws_iam_role.tlz_developer_ro.name}"
}
