

output "tlz_it_operations_role_arn" {
  description = "tlz_it_operations role arn"
  value = "${aws_iam_role.tlz_it_operations_role.arn}"
}

output "tlz_it_operations_role_id" {
  description = "tlz_it_operations role id"
  value = "${aws_iam_role.tlz_it_operations_role.id}"
}

output "tlz_it_operations_role_name" {
  description = "tlz_it_operations role name"
  value = "${aws_iam_role.tlz_it_operations_role.name}"
}
