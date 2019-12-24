# locals {
#   cloudcraft_account_arn = "arn:aws:iam::${var.cloudcraft_account_id}:root"
#   cloudcraft_name = "tlz_cloudcraft_read_only"
# }

# data "aws_iam_policy_document" "cloudcraft_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "AWS"
#       identifiers = ["${local.cloudcraft_account_arn}"]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "sts:ExternalId"
#       values   = ["${var.cloudcraft_external_id}"]
#     }

#     effect = "Allow"
#   }
# }

# module "cloudcraft_role_label" {
#   source  = "cloudposse/label/null"
#   version   = "~> 0.10.0"
#   context = "${var.tags_label_context}"
#   # We have hardcoded expectations for these default role names
#   name = "${local.cloudcraft_name}"
# }

# # cloudcraft role
# resource "aws_iam_role" "tlz_cloudcraft_read_only" {
#   name               = "${local.cloudcraft_name}"
#   assume_role_policy = "${data.aws_iam_policy_document.cloudcraft_assume_role_policy.json}"
#   description        = "Read only access for cloudcraft"
#   tags               = "${module.cloudcraft_role_label.tags}"
# }

# cloudcraft role policy attachments
# resource "aws_iam_role_policy_attachment" "tlz_cloudcraft_read_only" {
#   role       = "${aws_iam_role.tlz_cloudcraft_read_only.name}"
#   #cloudcraft wants the aws managed policy for readonly to operate
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }