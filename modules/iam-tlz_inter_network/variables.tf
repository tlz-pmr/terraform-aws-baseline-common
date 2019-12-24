variable "okta_provider_arn" {
  description = "The ARN of the Okta provider for the account being provisioned."
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