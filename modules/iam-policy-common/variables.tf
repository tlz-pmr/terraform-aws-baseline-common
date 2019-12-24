variable "okta_provider_arn" {
  description = "The ARN of the Okta provider for the account being provisioned."
}

variable "redlock_account_id" {
  description = "The account ID used by redlock"
  #this is a static account id from redlock that should not change.
  default = "188619942792"
}


variable "master_payer_account" {
  description = "AccountID of master_payer account"
}

variable "core_security_account" {
  description = "AccountID of core_security account"
}

variable "core_shared_services_account" {
  description = "AccountID of shared-services account"
}

variable "tlz_admin_role" {
  description = "Admin role that is used by shared-services to access target account"
}

variable "region" {
  description = "${var.region}"
}

variable "region_secondary" {
  description = "${var.region_secondary}"
}

variable "tags_label_context" {
  type        = "map"
  default     = {}
  description = "Label/Tag context to use for passing tagging expectations to label invocation"
}
