locals {
  billing_name = "tlz_billing_admin"
}
data "aws_iam_policy" "job_function_billing" {
  arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

data "template_file" "okta_trust_policy" {
  template = "${file("${path.module}/../../templates/tlz_okta_trust_policy.json.tpl")}"
  vars = {
    okta_provider_arn = "${var.okta_provider_arn}"
  }
}

module "billing_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.billing_name}"
}


resource "aws_iam_role" "tlz_billing_admin" {
  name               = "${local.billing_name}"
  description        = "This role is for users who needs to view billing information, set up payment, and authorize payment."
  assume_role_policy = "${data.template_file.okta_trust_policy.rendered}"
  tags               = "${module.billing_role_label.tags}"
}

resource "aws_iam_role_policy_attachment" "tlz_billing_admin_attachment" {
  role       = "${aws_iam_role.tlz_billing_admin.name}"
  policy_arn = "${data.aws_iam_policy.job_function_billing.arn}"
}
