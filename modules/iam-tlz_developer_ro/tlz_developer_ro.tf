######################
# AWS Managed Policies

# ReadOnlyAccess access policy
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
#####

locals {
  dev_ro_name = "tlz_developer_ro"
}

data "template_file" "okta_trust_policy" {
  template = "${file("${path.module}/../../templates/tlz_okta_trust_policy.json.tpl")}"
  vars = {
    okta_provider_arn = "${var.okta_provider_arn}"
  }
}

module "developer_ro_role_tags" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.dev_ro_name }"
}

# Admin role
resource "aws_iam_role" "tlz_developer_ro" {
  name               = "${local.dev_ro_name}"
  description        = "This is a federated role with readonly access to all resources"
  assume_role_policy = "${data.template_file.okta_trust_policy.rendered}"
  tags               = "${module.developer_ro_role_tags.tags}"
}

# Allows

# Admin role policy attachments
resource "aws_iam_role_policy_attachment" "tlz_developer_ro_allow" {
  role       = "${aws_iam_role.tlz_developer_ro.name}"
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}
