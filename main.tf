# Make baseline module version available
locals {
  baseline_version = "v0.1.7"
}

# Get the access to the effective Account ID in which Terraform is working.
data "aws_caller_identity" "current" { }

# Set account alias with name and account ID
resource "aws_iam_account_alias" "alias" {
  account_alias = "${replace("${var.account_name}-${data.aws_caller_identity.current.account_id}","_","-")}"
}

# IAM account password policy
resource "aws_iam_account_password_policy" "privileged" {
  minimum_password_length        = 16
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
  
}
