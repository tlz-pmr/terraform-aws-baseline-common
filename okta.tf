data "http" "okta_saml_metadata" {
  url = "https://${var.okta_provider_domain}/app/${var.okta_app_id}/sso/saml/metadata"

  # Optional request headers
  request_headers {
    "Accept" = "application/samlmetadata+xml;charset=utf-8"
  }
}

# Okta provider for the application
resource "aws_iam_saml_provider" "okta" {
  name                   = "OKTA_${upper(var.okta_environment)}"
  saml_metadata_document = "${data.http.okta_saml_metadata.body}"
}


# Sandbox accounts require the ability for users to log in interactively via Okta.
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithSAML"]

    principals = {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/OKTA_${upper(var.account_type)}"]
    }

    condition = {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
}
