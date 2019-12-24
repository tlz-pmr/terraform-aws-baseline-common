# AWS Config
module "aws_config_iam" {
  source             = "modules/aws-config-iam"
  config_logs_bucket = "${var.config_logs_bucket}"
  tags_label_context = "${var.tags_label_context}"
}

module "aws_config_service_primary" {
  source             = "modules/aws-config-service"
  config_logs_bucket = "${var.config_logs_bucket}"
  aws_iam_role_arn   = "${module.aws_config_iam.aws_iam_role_arn}"
}

module "aws_config_service_secondary" {
  source                        = "modules/aws-config-service"
  config_logs_bucket            = "${var.config_logs_bucket}"
  aws_iam_role_arn              = "${module.aws_config_iam.aws_iam_role_arn}"
  include_global_resource_types = true

  providers = {
    aws = "aws.secondary"
  }
}
