# BreakGlass trust policy
locals {
  breakglass_name = "tlz_breakglass"
}
data "aws_iam_policy_document" "breakglass_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.core_security_breakglass_account}:user/BreakglassUser",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

data "aws_iam_policy_document" "breakglass_child_user_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:AddUserToGroup",
      "iam:AttachUserPolicy",
      "iam:CreateUser",
      "iam:GetGroup",
      "iam:GetGroupPolicy",
      "iam:GetPolicy",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetUser",
      "iam:ListAttachedGroupPolicies",
      "iam:ListAttachedUserPolicies",
      "iam:ListGroupPolicies",
      "iam:ListGroups",
      "iam:ListGroupsForUser",
      "iam:ListPolicies",
      "iam:ListRolePolicies",
      "iam:ListRoles",
      "iam:ListUserPolicies",
      "iam:ListUsers",
    ]
  }
}

#BreakGlass child account policy
resource "aws_iam_policy" "tlz_breakglass_child_policy" {
  name        = "tlz_breakglass_child_user_policy"
  description = "This grants the required permissions for core breakglass account user in child accounts"
  policy      = "${data.aws_iam_policy_document.breakglass_child_user_policy.json}"
}

module "breakglass_role_label" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these special role names
  name = "${local.breakglass_name}"
}

# BreakGlass child user role
resource "aws_iam_role" "breakglass_role" {
  name               = "${local.breakglass_name}"
  assume_role_policy = "${data.aws_iam_policy_document.breakglass_assume_role_policy.json}"
  description        = "Role for breakglass role in child accounts"
  tags               = "${module.breakglass_role_label.tags}"
}

# BreakGlass role policy attachments
resource "aws_iam_role_policy_attachment" "breakglass_role_attach" {
  role       = "${aws_iam_role.breakglass_role.name}"
  policy_arn = "${aws_iam_policy.tlz_breakglass_child_policy.arn}"
}
