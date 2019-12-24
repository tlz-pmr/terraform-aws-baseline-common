locals {
  security_ir_name = "tlz_security_ir"
}

# SystemAdministrator managed policy
data "aws_iam_policy" "SystemAdministrator" {
  arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

module "security_ir_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.security_ir_name}"
}

# SecurityIR role
resource "aws_iam_role" "tlz_security_ir_role" {
  name               = "${local.security_ir_name}"
  description        = "Security incident response role used in the case of a cyber investigation and/or incident response triage. This role should not have full administrative access, but rather it should have least privilege access to conduct a cyber investigation"
  assume_role_policy = "${data.aws_iam_policy_document.okta_assume_role_policy.json}"
  tags               = "${module.security_ir_role_label.tags}"
}

# SecurityIR role policy attachments
resource "aws_iam_role_policy_attachment" "SecurityIR_SystemAdministrator_attach" {
  role       = "${aws_iam_role.tlz_security_ir_role.name}"
  policy_arn = "${data.aws_iam_policy.SystemAdministrator.arn}"
}
