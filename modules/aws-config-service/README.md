# Enables AWS Config service

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_iam\_role\_arn | The ARN of the IAM role the Config service will assume | string | - | yes |
| config\_delivery\_frequency | The frequency with which AWS Config delivers configuration snapshots. | string | `Six_Hours` | no |
| config\_logs\_bucket | The S3 bucket for AWS Config logs. | string | - | yes |
| include\_global\_resource\_types | Specifies whether AWS Config includes all supported types of global resources with the resources that it records | string | `false` | no |
