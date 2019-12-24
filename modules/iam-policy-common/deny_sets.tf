
# create deny sets

resource "aws_iam_policy" "tlz_deny_kmsdelete" {
  name        = "tlz_deny_kmsdelete"
  description = "tlz_deny_kmsdelete customer managed policy"
  policy      = "${file("${path.module}/templates/tlz_deny_kmsdelete.json")}"
}

data "aws_iam_policy_document" "deny_unauthorized_regions" {
  statement {
    effect      = "Deny"
    resources   = ["*"]
    not_actions = ["aws-portal:*", "iam:*", "organizations:*", "support:*", "sts:*"]

    condition = {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = ["${var.region}", "${var.region_secondary}"]
    }
  }
}

resource "aws_iam_policy" "tlz_deny_unauthorized_regions" {
  name        = "tlz_deny_unauthorized_regions"
  description = "tlz_deny_unauthorized_regions customer managed policy"
  policy      = "${data.aws_iam_policy_document.deny_unauthorized_regions.json}"
}


data "aws_iam_policy_document" "deny_marketplace_access" {
  statement {
    effect    = "Deny"
    resources = ["*"]
    actions   = ["aws-marketplace:*"]
  }
}

resource "aws_iam_policy" "tlz_deny_marketplace_access" {
  name        = "tlz_deny_marketplace_access"
  description = "tlz_deny_marketplace_access customer managed policy"
  policy      = "${data.aws_iam_policy_document.deny_marketplace_access.json}"
}

data "aws_iam_policy_document" "deny_billing" {
  statement {
    effect    = "Deny"
    resources = ["*"]
    actions   = ["aws-portal:Modify*"]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["aws-portal:View*"]
  }
}

resource "aws_iam_policy" "tlz_deny_billing" {
  name        = "tlz_deny_billing"
  description = "tlz_deny_billing customer managed policy"
  policy      = "${data.aws_iam_policy_document.deny_billing.json}"
}

data "aws_iam_policy_document" "deny_iam_delete" {
  statement {
    sid = "AllBaseLinePoliciesandRolesShouldStartWithtlz"

    actions = [
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:*Policy*",
    ]

    effect    = "Deny"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/tlz*", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/tlz*"]
  }
}

resource "aws_iam_policy" "tlz_deny_iam_delete" {
  name        = "tlz_deny_iam_delete"
  description = "tlz_deny_iam_delete customer managed policy"
  policy      = "${data.aws_iam_policy_document.deny_iam_delete.json}"
}

resource "aws_iam_policy" "tlz_deny_guard_duty" {
  name        = "tlz_deny_guard_duty"
  description = "tlz_deny_guard_duty customer managed policy"
  policy      = "${file("${path.module}/templates/tlz_deny_guard_duty.json")}"
}

resource "aws_iam_policy" "tlz_deny_route53_domains" {
  name        = "tlz_deny_route53domains"
  description = "tlz_deny_route53_domains customer managed policy"
  policy      = "${file("${path.module}/templates/tlz_deny_route53domains.json")}"
}

resource "aws_iam_policy" "tlz_deny_vpc_peering" {
  name       = "tlz_deny_vpc_peering"
  description = "tlz_deny_vpc_peering customer managed policy"
  policy      = "${file("${path.module}/templates/tlz_deny_vpc_peering.json")}"
}

resource "aws_iam_policy" "tlz_deny_external_networking" {
  name       = "tlz_deny_external_networking"
  description = "tlz_deny_external_networking customer managed policy"
  policy      = "${file("${path.module}/templates/tlz_deny_external_networking.json")}"
}
