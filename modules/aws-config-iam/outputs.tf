output "aws_iam_role_arn" {
  description = "ARN of IAM role for Config"
  value       = "${aws_iam_role.aws_config.arn}"
}
