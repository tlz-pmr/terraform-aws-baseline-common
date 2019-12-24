locals {
  inter_name = "tlz_inter_network"
}

# it_operations role
data "template_file" "okta_trust_policy" {
  template = "${file("${path.module}/../../templates/tlz_okta_trust_policy.json.tpl")}"
  vars = {
    okta_provider_arn = "${var.okta_provider_arn}"
  }
}

module "internetwork_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.inter_name}"
}


resource "aws_iam_role" "tlz_inter_network_role" {
  name               = "${local.inter_name}"
  description        = "This is the only role that is allowed to modify external access or VPC-Peering. In addition to the usual network administrator capabilities this role grants permissions to create and maintain connectivity external to VPCs and accounts including, Amazon Virtual Private Network (VPN), Internet Gateways (IGW), and AWS Direct Connect"
  assume_role_policy = "${data.template_file.okta_trust_policy.rendered}"
  tags               = "${module.internetwork_role_label.tags}"
}

# Allows
data "aws_iam_policy" "NetworkAdministrator" {
  arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
}

resource "aws_iam_role_policy_attachment" "tlz_inter_network_netadmin" {
  role       = "${aws_iam_role.tlz_inter_network_role.name}"
  policy_arn = "${data.aws_iam_policy.NetworkAdministrator.arn}"
}

# Deny
resource "aws_iam_role_policy_attachment" "tlz_deny_kmsdelete_attachment" {
  role         = "${aws_iam_role.tlz_inter_network_role.name}"
  policy_arn   = "${var.deny_policy_arns["tlz_deny_kmsdelete"]}"
}

resource "aws_iam_role_policy_attachment" "tlz_deny_guard_duty_attachment" {
  role       = "${aws_iam_role.tlz_inter_network_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_guard_duty"]}"
}

resource "aws_iam_role_policy_attachment" "tlz_deny_iam_delete_attachment" {
  role       = "${aws_iam_role.tlz_inter_network_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_iam_delete"]}"
}
