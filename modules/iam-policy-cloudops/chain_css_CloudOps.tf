# CloudOps custom policy
locals {
  cloud_ops_name = "tlz_cloudops"
}
data "aws_iam_policy_document" "tlz_CloudOps_denyset" {
  statement {
    effect    = "Deny"
    resources = ["*"]
    actions   = ["sts:*"]
  }
}

# CloudOps managed policy
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# CloudOps role policy
resource "aws_iam_policy" "tlz_CloudOps_denyset" {
  name        = "tlz_cloudops_denyset"
  description = "This denies all assume role capabilities"
  policy      = "${data.aws_iam_policy_document.tlz_CloudOps_denyset.json}"
}

module "cloud_ops_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.cloud_ops_name}"
}

# CloudOps role
resource "aws_iam_role" "tlz_CloudOps_role" {
  name               = "${local.cloud_ops_name}"
  description        = "This role provides ReadOnly access throughout the AWS Environment. It should have ReadOnly access to AWS infrastructure services and Organizations (including the master account email and organization limitations) without the ability to modify networking or elevate their own privileges."
  assume_role_policy = "${data.aws_iam_policy_document.okta_assume_role_policy.json}"
  tags               = "${module.cloud_ops_role_label.tags}"
}

# CloudOps role policy attachments
resource "aws_iam_role_policy_attachment" "tlz_CloudOps_readonly" {
  role       = "${aws_iam_role.tlz_CloudOps_role.name}"
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "tlz_CloudOps_denyset" {
  role       = "${aws_iam_role.tlz_CloudOps_role.name}"
  policy_arn = "${aws_iam_policy.tlz_CloudOps_denyset.arn}"
}
