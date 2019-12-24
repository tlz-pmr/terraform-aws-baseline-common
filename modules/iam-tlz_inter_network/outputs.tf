

output "tlz_inter_network_role_arn" {
  description = "tlz_inter_network role arn"
  value = "${aws_iam_role.tlz_inter_network_role.arn}"
}

output "tlz_inter_network_role_id" {
  description = "tlz_inter_network role id"
  value = "${aws_iam_role.tlz_inter_network_role.id}"
}

output "tlz_inter_network_role_name" {
  description = "tlz_inter_network role name"
  value = "${aws_iam_role.tlz_inter_network_role.name}"
}
