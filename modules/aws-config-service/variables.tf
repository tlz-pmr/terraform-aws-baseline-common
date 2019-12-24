variable "config_logs_bucket" {
  description = "The S3 bucket for AWS Config logs."
  type        = "string"
}

variable "config_delivery_frequency" {
  description = "The frequency with which AWS Config delivers configuration snapshots."
  default     = "Six_Hours"
  type        = "string"
}

variable "aws_iam_role_arn" {
  description = "The ARN of the IAM role the Config service will assume"
}

variable "include_global_resource_types" {
  description = "Specifies whether AWS Config includes all supported types of global resources with the resources that it records"
  default     = true
}
