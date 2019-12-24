# AWS Provider Variables
variable "account_id" {
  description = "The AWS ID of the account"
}

variable "account_name" {
  description = "The name for the account"
}

# AWS Account type
variable "account_type" {
  description = "AWS Account type application or sandbox"
}

variable "okta_provider_domain" {
  description = "The domain name of the IDP.  This is concatenated with the app name and should be in the format 'site.domain.tld' (no protocol or trailing /)."
}

variable "okta_app_id" {
  description = "The Okta app ID for SSO configuration."
}

variable "tfe_host_name" {
  description = "host_name for ptfe"
}

variable "tfe_org_name" {
  description = "ptfe organization name"
}

variable "tfe_avm_workspace_name" {
  description = "Name of avm workspace"
}

# variable "master_payer_account" {
#   description = "AccountID of master_payer account"
# }

# variable "core_security_account" {
#   description = "AccountID of core_security account"
# }

# variable "core_shared_services_account" {
#   description = "AccountID of shared-services account"
# }

variable "region" {
  description = "AWS Region to deploy to"
}

variable "region_secondary" {
  description = "AWS secondary region to deploy to"
}

variable "role_name" {
  description = "AWS role name to assume"
}

variable "config_logs_bucket" {
  description = "Name of config_logs_bucket created in core-logging-account"
}
variable "okta_environment" {
  description = "SBX (Sandbox ), CORE (Core), Application accounts: NPD (non-production), PRD(Production)"
}

variable "tags_label_context" {
  type        = "map"
  default     = {}
  description = "Label/Tag context to use for passing tagging expectations to label invocation"
}
