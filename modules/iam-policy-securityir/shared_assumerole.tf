######################
# Assume Role Policies

# # Okta assume role policy
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