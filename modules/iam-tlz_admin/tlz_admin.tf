locals {
  tlz_admin_name = "tlz_admin"
}

######################
# AWS Managed Policies

# Administrator access policy
data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
#####

data "template_file" "okta_trust_policy" {
  template = "${file("${path.module}/../../templates/tlz_okta_trust_policy.json.tpl")}"
  vars = {
    okta_provider_arn = "${var.okta_provider_arn}"
  }
}

module "admin_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.tlz_admin_name}"
}

# Admin role
resource "aws_iam_role" "tlz_admin" {
  name               = "${local.tlz_admin_name}"
  description        = "This group has full access (provisioning/removal/modify) on all AWS services within the root account including IAM user administration"
  assume_role_policy = "${data.template_file.okta_trust_policy.rendered}"
  tags               =  "${module.admin_role_label.tags}"
}

# Allows

# Admin role policy attachments
resource "aws_iam_role_policy_attachment" "Admin_role_administrator_attach" {
  role       = "${aws_iam_role.tlz_admin.name}"
  policy_arn = "${data.aws_iam_policy.AdministratorAccess.arn}"
}

# Denys

resource "aws_iam_role_policy_attachment" "tlz_deny_kmsdelete_attachment" {
  role          = "${aws_iam_role.tlz_admin.name}"
  policy_arn   = "${var.deny_policy_arns["tlz_deny_kmsdelete"]}"
}

resource "aws_iam_role_policy_attachment" "tlz_deny_billing_attachment" {
  role          = "${aws_iam_role.tlz_admin.name}"
  policy_arn   = "${var.deny_policy_arns["tlz_deny_billing"]}"
}

locals {
  additional_denysets   = "${upper(var.okta_environment) == "CORE" ? 0 : 1 }"
}

data "template_file" "additional_denysets" {
  template = "${file("${path.module}/../../templates/tlz_deny_admin_app_accounts.json.tpl")}"
  vars = {
    account = "${data.aws_caller_identity.current.account_id}"
  }
}
resource "aws_iam_role_policy" "tlz_deny_additional_denysets" {
  count      = "${local.additional_denysets}"
  name = "tlz_deny_non_core_denysets"
  role       = "${aws_iam_role.tlz_admin.name}"
  policy      = "${data.template_file.additional_denysets.rendered}"
}
