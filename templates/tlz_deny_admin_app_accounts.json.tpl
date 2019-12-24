{
    "Version": "2012-10-17",
    "Statement": [
                  {
                    "Sid": "DenyPassRoleThreatVector",
                    "Action": [
                          "iam:PassRole"
                            ],
                    "Effect": "Deny",
                    "Resource": "*",
                    "Condition": {
                          "StringLike": {
                                    "iam:PassedToService": "*"
                          }
                    }
                  },
                  {
                    "Sid": "DenyBillingPortalAccess",
                    "Action": "aws-portal:*",
                    "Effect": "Deny",
                    "Resource": "*"
                  },
                  {
                    "Sid": "DenyOrganizationsAccess",
                    "Action": "organizations:*",
                    "Effect": "Deny",
                    "Resource": "*"
                  },
                  {
                    "Sid": "DenyKeyKMSActionsNeedsToBeUpdatedBasedOnSSMUsage",
                    "Action": [
                          "kms:CancelKeyDeletion",
                          "kms:DeleteAlias",
                          "kms:DeleteImportedKeyMaterial",
                          "kms:DisableKey",
                          "kms:DisableKeyRotation",
                          "kms:RetireGrant",
                          "kms:UntagResource"
                          ],
                    "Effect": "Deny",
                    "Resource": "*"
                  },
                  {
                      "Sid": "DenyLocalIAMActivities",
                      "Action": [
                                  "iam:AddUserToGroup",
                                  "iam:ChangePassword",
                                  "iam:CreateAccessKey",
                                  "iam:CreateUser",
                                  "iam:DeactivateMFADevice",
                                  "iam:DeleteUser",
                                  "iam:DeleteUserPermissionsBoundary",
                                  "iam:ResyncMFADevice",
                                  "iam:UpdateAccessKey",
                                  "iam:UpdateUser"
                                ],
                    "Effect": "Deny",
                    "Resource": "*"
                  },
                  {
                        "Sid": "DenyBaselinePolicyModificationsMightNeedBaseLinePolicyNamingConvention",
                        "Action": [
                                  "iam:CreatePolicyVersion",
                                  "iam:DeletePolicy",
                                  "iam:DeletePolicyVersion"
                                ],
                        "Effect": "Deny",
                        "Resource": "*",
                        "Condition": {
                              "StringLike": {
                                    "aws:PrincipalArn": "arn:aws:iam::${account}:policy/*"
                                      }
                        }
                  }
      ]
}
