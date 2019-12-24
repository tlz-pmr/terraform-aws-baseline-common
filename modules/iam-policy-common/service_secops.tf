locals {
  tlz_sec_role = "tlz_security_operations"
}

# secops Monitoring SIEM read only policy
data "aws_iam_policy_document" "secops_aws_monitoring_role" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:ListQueues",
      "sqs:GetQueueUrl",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
      "s3:GetBucketTagging",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketLogging",
      "s3:GetLifecycleConfiguration",
      "s3:GetBucketCORS",
      "config:DeliverConfigSnapshot",
      "config:DescribeConfigRules",
      "config:DescribeConfigRuleEvaluationStatus",
      "config:GetComplianceDetailsByConfigRule",
      "config:GetComplianceSummaryByConfigRule",
      "iam:GetUser",
      "iam:ListUsers",
      "iam:GetAccountPasswordPolicy",
      "iam:ListAccessKeys",
      "iam:GetAccessKeyLastUsed",
      "autoscaling:Describe*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "sns:Get*",
      "sns:List*",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "ec2:DescribeInstances",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeRegions",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
      "ec2:DescribeImages",
      "ec2:DescribeAddresses",
      "lambda:ListFunctions",
      "rds:DescribeDBInstances",
      "cloudfront:ListDistributions",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeListeners",
      "inspector:Describe*",
      "inspector:List*",
      "kinesis:DescribeStream",
      "kinesis:ListStreams",
    ]
  }
}

module "secops_role_tags" {
  source  = "cloudposse/label/null"
  version   = "~> 0.10.0"
  context = "${var.tags_label_context}"
  # We have hardcoded expectations for these default role names
  name = "${local.tlz_sec_role}"
}

# secops  role
resource "aws_iam_role" "secops_aws_monitoring_role" {
  name               = "${local.tlz_sec_role}"
  assume_role_policy = "${data.aws_iam_policy_document.okta_assume_role_policy.json}"
  description        = "Security Auditor Role for InfoSec. Will have Read-only access to log data and other configuration data of AWS resources"
  tags               = "${module.secops_role_tags.tags}"
}

# secops role policy attachments
resource "aws_iam_role_policy_attachment" "secops_aws_monitoring_role_sec_audit" {
  role       = "${aws_iam_role.secops_aws_monitoring_role.name}"
  policy_arn = "${data.aws_iam_policy.SecurityAudit.arn}"
}

resource "aws_iam_role_policy" "secops_aws_monitoring_role" {
  role       = "${aws_iam_role.secops_aws_monitoring_role.name}"
  policy     = "${data.aws_iam_policy_document.secops_aws_monitoring_role.json}"
  name       = "tlz_security_operations"
}
