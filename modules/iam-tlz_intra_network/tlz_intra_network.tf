locals {
  intra_name = "tlz_intra_network"
}

# it_operations role
data "template_file" "okta_trust_policy" {
  template = "${file("${path.module}/../../templates/tlz_okta_trust_policy.json.tpl")}"
  vars = {
    okta_provider_arn = "${var.okta_provider_arn}"
  }
}

module "intranetwork_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.intra_name}"
}


resource "aws_iam_role" "tlz_intra_network_role" {
  name               = "${local.intra_name}"
  description        = "Handles VPC level networking. The role is focused on day to day network tasks and grants permissions to create and maintain connectivity and infrastructure including managing routing, subnets, and VPCs and VPC endpoints"
  assume_role_policy = "${data.template_file.okta_trust_policy.rendered}"
  tags               = "${module.intranetwork_role_label.tags}"
}

# Allows
data "aws_iam_policy" "NetworkAdministrator" {
  arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
}

data "aws_iam_policy" "AWSDirectConnectReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AWSDirectConnectReadOnlyAccess"
}

# it_operations role managed policy attachments
resource "aws_iam_role_policy_attachment" "tlz_intra_network_dx_readonly" {
  role       = "${aws_iam_role.tlz_intra_network_role.name}"
  policy_arn = "${data.aws_iam_policy.AWSDirectConnectReadOnlyAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "tlz_intra_network_netadmin" {
  role       = "${aws_iam_role.tlz_intra_network_role.name}"
  policy_arn = "${data.aws_iam_policy.NetworkAdministrator.arn}"
}

# Deny

# Deny External Networking
resource "aws_iam_role_policy_attachment" "tlz_deny_external_networking_attachment" {
  role       = "${aws_iam_role.tlz_intra_network_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_external_networking"]}"
}

# Deny kmsdelete
resource "aws_iam_role_policy_attachment" "tlz_deny_kmsdelete_attachment" {
  role        = "${aws_iam_role.tlz_intra_network_role.name}"
  policy_arn  = "${var.deny_policy_arns["tlz_deny_kmsdelete"]}"
}

# Deny Guard Duty
resource "aws_iam_role_policy_attachment" "tlz_deny_guard_duty_attachment" {
  role       = "${aws_iam_role.tlz_intra_network_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_guard_duty"]}"
}

# Deny IAM Delete
resource "aws_iam_role_policy_attachment" "tlz_deny_iam_delete_attachment" {
  role       = "${aws_iam_role.tlz_intra_network_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_iam_delete"]}"
}

# Deny Route 53 domains
resource "aws_iam_role_policy_attachment" "tlz_deny_route53_domains_attachment" {
  role       = "${aws_iam_role.tlz_intra_network_role.name}"
  policy_arn = "${var.deny_policy_arns["tlz_deny_route53_domains"]}"
}
