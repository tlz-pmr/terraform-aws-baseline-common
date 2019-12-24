# Get the access to the effective Account ID in which Terraform is working.
data "aws_caller_identity" "current" {}

locals {
  tlz_awsconfig_name = "tlz_awsconfig"
}

module "logging_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.tlz_awsconfig_name}"
}

# IAM Policy creation and assumption
resource "aws_iam_role" "aws_config" {
  name               = "${local.tlz_awsconfig_name}"
  assume_role_policy = "${data.aws_iam_policy_document.aws_config_assume_role_policy.json}"
  description        = "This role allows AWSConfig service to write the config logs to S3 bucket in central logging acccount"
  tags               = "${module.logging_role_label.tags}"
}

# Allow IAM policy to assume the role for AWS Config
data "aws_iam_policy_document" "aws_config_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

# Allows AWS Config IAM role to access the S3 bucket where AWS Config records
# are stored.
data "aws_iam_policy_document" "aws_config_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:PutObject*"]

    resources = ["arn:aws:s3:::${var.config_logs_bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetBucketAcl"]

    resources = ["arn:aws:s3:::${var.config_logs_bucket}"]
  }
}

resource "aws_iam_policy" "aws-config-policy" {
  name   = "${local.tlz_awsconfig_name}"
  policy = "${data.aws_iam_policy_document.aws_config_policy.json}"
}

resource "aws_iam_policy_attachment" "aws-config-policy" {
  name       = "${local.tlz_awsconfig_name}"
  roles      = ["${aws_iam_role.aws_config.name}"]
  policy_arn = "${aws_iam_policy.aws-config-policy.arn}"
}

resource "aws_iam_policy_attachment" "managed-policy" {
  name       = "tlz_awsconfig_managed_policy"
  roles      = ["${aws_iam_role.aws_config.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
