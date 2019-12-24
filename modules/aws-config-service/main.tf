# AWS Config Service
resource "aws_config_configuration_recorder" "main" {
  name     = "tlz_awsconfig"
  role_arn = "${var.aws_iam_role_arn}"

  recording_group = {
    all_supported                 = true
    include_global_resource_types = "${var.include_global_resource_types}"
  }
}

resource "aws_config_delivery_channel" "main" {
  name           = "tlz_awsconfig"
  s3_bucket_name = "${var.config_logs_bucket}"

  snapshot_delivery_properties = {
    delivery_frequency = "${var.config_delivery_frequency}"
  }

  depends_on = ["aws_config_configuration_recorder.main"]
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = "tlz_awsconfig"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.main"]
}
