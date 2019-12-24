# variable "core_shared_services_account" {
#   description = "AccountID of shared-services account"
# }

# variable "tlz_admin_role" {
#   description = "Admin role that is used by shared-services to access target account"
# }

variable "okta_provider_arn" {
  description = "The ARN of the Okta provider for the account being provisioned."
}

variable "okta_environment" {
  description = "SBX (Sandbox ), CORE (Core), Application accounts: NPD (non-production), PRD(Production)"
  default     = "CORE"
}

variable "deny_policy_arns" {
  description = "The ARNs of the deny sets as a map"
  type        = "map"
}

variable "tags_label_context" {
  type        = "map"
  default     = {}
  description = "Label/Tag context to use for passing tagging expectations to label invocation"
}
