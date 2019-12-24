# Get the access to the effective Account ID in which Terraform is working.
data "aws_caller_identity" "current" {}
