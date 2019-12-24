output "tlz_developer_role_arn" {
  description = "tlz_developer role arn"
  value = "${aws_iam_role.tlz_developer.*.arn}"
}

output "tlz_developer_role_id" {
  description = "tlz_developer role id"
  value = "${aws_iam_role.tlz_developer.*.id}"
}

output "tlz_developer_role_name" {
  description = "tlz_developer role name"
  value = "${aws_iam_role.tlz_developer.*.name}"
}
