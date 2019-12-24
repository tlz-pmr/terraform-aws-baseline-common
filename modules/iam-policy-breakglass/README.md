iam-policy
==========
Terraform AWS developer/sandbox ABC IAM roles and policies


What this is
------------
This creates the roles and policies required for a developer/sandbox account.


### This will create the following resources: ###
```
AWS IAM Okta roles:
  * Developer

AWS Chain roles:
  * Admin
  * SecurityIR
  * CloudOps
  * breakglass
  

AWS IAM Service roles:
  * RedlockReadOnly
  * secops_AWS_Monitoring_Role
  * BreakGlass
  * GlobalOrgAdmin
  * OrganizationAccountAccessRole
  

IAM policies:
  * DeveloperBillingAccess
  * RedlockReadOnly
  * secops_AWS_Monitoring_Role-DescribePolicy
  * developerROdenyset
  * CloudOpsdenyset
  * Admindenyset
  * abc_deny_iam_delete
```

<!--BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK-->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| secops\_monitoring\_aws\_account\_arn | The ARN of the role used by secops Splunk to view resources | string | `arn:aws:iam::111111111111:role/splunk_ec2_api_server_role` | no |
| okta\_provider\_arn | The ARN of the Okta provider for the account being provisioned. | string | - | yes |
| redlock\_aws\_account\_arn | The ARN of the account used by Redlock service to view resources | string | `arn:aws:iam::111111111111:root` | no |
| redlock\_id | The value entered into Redlock to provide an extra layer of security validation | string | `abc-redlock` | no |

<!--END OF PRE-COMMIT-TERRAFORM DOCS HOOK-->
