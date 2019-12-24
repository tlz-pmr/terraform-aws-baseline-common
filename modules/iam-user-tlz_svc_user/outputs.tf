

output "tlz_service_user_arn" {
  description = "service user arn"
  value = "${aws_iam_user.service_user.arn}"
}

output "tlz_service_user_name" {
  description = "service user name"
  value = "${aws_iam_user.service_user.name}"
}
