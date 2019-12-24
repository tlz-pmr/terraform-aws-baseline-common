variable "core_security_breakglass_account" {
  description = "AccountID of core_security_breakglass account"
}

variable "tags_label_context" {
  type        = "map"
  default     = {}
  description = "Label/Tag context to use for passing tagging expectations to label invocation"
}
