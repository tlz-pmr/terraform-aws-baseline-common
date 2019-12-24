locals {
  ops_role = "tlz_it_operations"
}

# it_operations role
data "template_file" "okta_trust_policy" {
  template = "${file("${path.module}/../../templates/tlz_okta_trust_policy.json.tpl")}"
  vars = {
    okta_provider_arn = "${var.okta_provider_arn}"
  }
}

module "it_ops_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.ops_role}"
}

resource "aws_iam_role" "tlz_it_operations_role" {
  name               = "${local.ops_role}"
  description        = "Operations role, typically used by operations teams building things in AWS.They should be allowed to control resources, while denied ability to elevate their own privileges or change networking frameworks"
  assume_role_policy = "${data.template_file.okta_trust_policy.rendered}"
  tags               = "${module.it_ops_role_label.tags}"
}

# Allows
data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
data "aws_iam_policy" "AmazonEC2FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "aws_iam_policy" "AmazonRDSFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
data "aws_iam_policy" "IAMReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

# it_operations role managed policy attachments
resource "aws_iam_role_policy_attachment" "tlz_it_operations_s3_fullaccess" {
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonS3FullAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "tlz_it_operations_ec2_full" {
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonEC2FullAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "tlz_it_operations_rds_full" {
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonRDSFullAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "tlz_it_operations_iam_readonly" {
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn = "${data.aws_iam_policy.IAMReadOnlyAccess.arn}"
}

# it_operations custom policy attach
data "aws_iam_policy_document" "tlz_it_operations_iam_access_keys" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = [
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:UpdateAccessKey"
    ]
  }
}

resource "aws_iam_role_policy" "tlz_it_operations_iam_access_keys" {
  name        = "tlz_allow_iam_manage_access_keys"
  policy      = "${data.aws_iam_policy_document.tlz_it_operations_iam_access_keys.json}"
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
}

# Deny

# Deny External Networking
resource "aws_iam_role_policy_attachment" "tlz_deny_external_networking_attachment" {
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_external_networking"]}"
}

# Deny kmsdelete
resource "aws_iam_role_policy_attachment" "tlz_deny_kmsdelete_attachment" {
  role        = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn  = "${var.deny_policy_arns["tlz_deny_kmsdelete"]}"
}

# Deny VPC Peering
resource "aws_iam_role_policy_attachment" "tlz_deny_vpc_peering_attachment" {
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_vpc_peering"]}"
}

# Deny Route 53 domains
resource "aws_iam_role_policy_attachment" "tlz_deny_route53_domains_attachment" {
  role       = "${aws_iam_role.tlz_it_operations_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_route53_domains"]}"
}
