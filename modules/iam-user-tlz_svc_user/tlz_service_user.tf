# Create the local Terraform user
module "service_user_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${var.user_name}"
}

resource "aws_iam_user" "service_user" {
  name          = "${var.user_name}"
  force_destroy = true
  tags          = "${module.service_user_label.tags}"
}

resource "aws_iam_user_policy_attachment" "service_user" {
  user       = "${aws_iam_user.service_user.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
