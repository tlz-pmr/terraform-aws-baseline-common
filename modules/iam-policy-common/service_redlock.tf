resource "random_pet" "externalID" {
  prefix = "redlock"
  length = "3"
}

locals {
  redlock_account_arn = "arn:aws:iam::${var.redlock_account_id}:root"
  redlock_name = "tlz_redlock_read_only"
}

# Redlock assume role policy
data "aws_iam_policy_document" "redlock_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${local.redlock_account_arn}"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${random_pet.externalID.id}"]
    }

    effect = "Allow"
  }
}

# Redlock Read Only Policy
data "aws_iam_policy_document" "tlz_redlock_read_only" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "acm:List*",
      "apigateway:GET",
      "appstream:Describe*",
      "cloudtrail:GetEventSelectors",
      "cloudtrail:LookupEvents",
      "cloudsearch:Describe*",
      "dynamodb:DescribeTable",
      "ds:Describe*",
      "elasticache:List*",
      "eks:List*",
      "eks:Describe*",
      "elasticfilesystem:Describe*",
      "elasticmapreduce:Describe*",
      "elasticmapreduce:List*",
      "inspector:Describe*",
      "inspector:List*",
      "glacier:List*",
      "glacier:GetVaultAccessPolicy",
      "glacier:GetVaultNotifications",
      "glacier:GetVaultLock",
      "glacier:GetDataRetrievalPolicy",
      "guardduty:List*",
      "guardduty:Get*",
      "iam:SimulatePrincipalPolicy",
      "iam:SimulateCustomPolicy",
      "kinesis:Describe*",
      "kinesis:List*",
      "rds:ListTagsForResource",
      "sns:List*",
      "sns:Get*",
      "sqs:SendMessage",
      "logs:FilterLogEvents",
      "logs:Get*",
      "logs:Describe*",
      "secretsmanager:List*",
      "secretsmanager:Describe*",
      "lambda:List*",
      "s3:GetAccountPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "ssm:DescribeParameters",
      "ssm:ListTagsForResource",
      "ssm:GetParameters",
      "elasticbeanstalk:DescribeEnvironments",
      "elasticbeanstalk:ListTagsForResource",
      "elasticbeanstalk:DescribeEnvironmentResources",
      "autoscaling:DescribeLaunchConfigurations",
      "cognito-identity:ListTagsForResource",
      "cognito-idp:ListTagsForResource",
    ]
  }
}

resource "aws_iam_policy" "tlz_redlock_read_only" {
  name        = "tlz_redlock_read_only"
  description = "This grants read only access for the Redlock service"
  policy      = "${data.aws_iam_policy_document.tlz_redlock_read_only.json}"
}

module "redlock_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.redlock_name}"
}


# Redlock role
resource "aws_iam_role" "tlz_redlock_read_only" {
  name               = "${local.redlock_name}"
  assume_role_policy = "${data.aws_iam_policy_document.redlock_assume_role_policy.json}"
  description        = "Read only access for Redlock"
  tags               = "${module.redlock_role_label.tags}"
}

# redlock role policy attachments
resource "aws_iam_role_policy_attachment" "tlz_redlock_read_only_AWS1" {
  role       = "${aws_iam_role.tlz_redlock_read_only.name}"
  policy_arn = "${data.aws_iam_policy.SecurityAudit.arn}"
}

resource "aws_iam_role_policy_attachment" "tlz_redlock_read_only" {
  role       = "${aws_iam_role.tlz_redlock_read_only.name}"
  policy_arn = "${aws_iam_policy.tlz_redlock_read_only.arn}"
}
