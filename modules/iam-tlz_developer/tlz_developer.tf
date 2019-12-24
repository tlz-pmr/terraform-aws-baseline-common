######################
# AWS Managed Policies

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


data "template_file" "okta_trust_policy" {
  template = "${file("${path.module}/../../templates/tlz_okta_trust_policy.json.tpl")}"
  vars = {
    okta_provider_arn = "${var.okta_provider_arn}"
  }
}

locals {
  dev_role_count   = "${upper(var.okta_environment) == "PRD" ? 0 : 1 }"
  tlz_dev = "tlz_developer"
}

module "developer_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.tlz_dev}"
}

# developer role
resource "aws_iam_role" "tlz_developer" {
  count              = "${local.dev_role_count}"
  name               = "${local.tlz_dev}"
  description        = "This group has Administrator access with few limitations defined by deny sets. This role has following deny sets implemented for iam, security, and networking"
  assume_role_policy = "${data.template_file.okta_trust_policy.rendered}"
  tags               = "${module.developer_role_label.tags}"
}

# Allows

# Admin role policy attachments
resource "aws_iam_role_policy_attachment" "Admin_role_administrator_attach" {
  count      = "${local.dev_role_count}"
  role       = "${aws_iam_role.tlz_developer.name}"
  policy_arn = "${data.aws_iam_policy.AdministratorAccess.arn}"
}

### Denys

# Deny kmsdelete
resource "aws_iam_role_policy_attachment" "tlz_deny_kmsdelete_attachment" {
  count       = "${local.dev_role_count}"
  role        = "${aws_iam_role.tlz_developer.name}"
  policy_arn  = "${var.deny_policy_arns["tlz_deny_kmsdelete"]}"
}

# Deny Unauthorized Regions
resource "aws_iam_role_policy_attachment" "tlz_deny_unauthorized_regions_attachment" {
  count       = "${local.dev_role_count}"
  role         = "${aws_iam_role.tlz_developer.name}"
  policy_arn   = "${var.deny_policy_arns["tlz_deny_unauthorized_regions"]}"
}

# Deny MarketPlace Access
resource "aws_iam_role_policy_attachment" "tlz_deny_marketplace_access_attachment" {
  count       = "${local.dev_role_count}"
  role         = "${aws_iam_role.tlz_developer.name}"
  policy_arn   = "${var.deny_policy_arns["tlz_deny_marketplace_access"]}"
}

# Deny Billing
resource "aws_iam_role_policy_attachment" "tlz_deny_billing_attachment" {
  count       = "${local.dev_role_count}"
  role         = "${aws_iam_role.tlz_developer.name}"
  policy_arn   = "${var.deny_policy_arns["tlz_deny_billing"]}"
}

# Deny IAM Delete
resource "aws_iam_role_policy_attachment" "tlz_deny_iam_delete_attachment" {
  count      = "${local.dev_role_count}"
  role       = "${aws_iam_role.tlz_developer.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_iam_delete"]}"
}

# Deny Guard Duty
resource "aws_iam_role_policy_attachment" "tlz_deny_guard_duty_attachment" {
  count      = "${local.dev_role_count}"
  role       = "${aws_iam_role.tlz_developer.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_guard_duty"]}"
}

# Deny Route 53 domains
resource "aws_iam_role_policy_attachment" "tlz_deny_route53_domains_attachment" {
  count      = "${local.dev_role_count}"
  role       = "${aws_iam_role.tlz_developer.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_route53_domains"]}"
}

# Deny VPC Peering
resource "aws_iam_role_policy_attachment" "tlz_deny_vpc_peering_attachment" {
  count      = "${local.dev_role_count}"
  role       = "${aws_iam_role.tlz_developer.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_vpc_peering"]}"
}

# Deny External Networking
resource "aws_iam_role_policy_attachment" "tlz_deny_external_networking_attachment" {
  count      = "${local.dev_role_count}"
  role       = "${aws_iam_role.tlz_developer.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_external_networking"]}"
}
