terraform-aws-baseline-common
==============================
Common module used by all account_types

Overview
--------
This module provides common baseline configuration for all account templates supported by Terraform LandingZone solution. The module itself is called from baseline-core,  baseline-application and baseline-sandbox modules.


Process
-------
The baseline process is made up of the following steps:

1. Sets a variable for the current git tag version
2. Connects to the core-logging account TFE backend
3. Sets the AWS Account Alias
4. Sets up the Okta Single Sign On identity provider
5. Calls sub-modules to create roles and policies. See [here](/projects/TLZ-CORE/repos/tlz-docs). Browse to docs/security/iam/index.md for more information.
6. Configures AWS Config for US-EAST-2 and US-EAST-1
7. Sets the IAM password policy



Usage
-----
The module expects the following inputs and returns listed outputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account\_name | The name for the account | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| account\_alias | Account alias |
| baseline\_version | Version of the baseline module |
