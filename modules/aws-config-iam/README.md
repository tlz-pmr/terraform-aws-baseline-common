# Sets up an IAM role for AWS Config and allows it to write to an S3 bucket

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| config\_logs\_bucket | The S3 bucket for AWS Config logs. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_iam\_role\_arn | ARN of IAM role for Config |
