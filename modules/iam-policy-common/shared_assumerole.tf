######################
# Assume Role Policies

# Okta assume role policy
data "aws_iam_policy_document" "okta_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["${var.okta_provider_arn}"]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }

    effect = "Allow"
  }
}

# Chain trust policy
data "aws_iam_policy_document" "chain_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.master_payer_account}:root",
        "arn:aws:iam::${var.core_shared_services_account}:root",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}
