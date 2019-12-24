data "terraform_remote_state" "avm" {
  backend = "remote"

  config {
    organization = "${var.tfe_org_name}"
    hostname     = "${var.tfe_host_name}"

    workspaces {
      name = "${var.tfe_avm_workspace_name}"
    }
  }
}

# Roles and policies
module "iam-policy" {
  source                       = "modules/iam-policy-common"
  # master_payer_account         = "${var.master_payer_account}"
  # core_security_account        = "${var.core_security_account}"
  # core_shared_services_account = "${var.core_shared_services_account}"
  master_payer_account         = "${data.terraform_remote_state.avm.master_payer_account}"
  core_security_account        = "${data.terraform_remote_state.avm.core_security_account}"
  core_shared_services_account = "${data.terraform_remote_state.avm.core_shared_services_account}"

  tlz_admin_role               = "${var.role_name}"
  okta_provider_arn            = "${aws_iam_saml_provider.okta.arn}"
  region                       = "${var.region}"
  region_secondary             = "${var.region_secondary}"
  tags_label_context         = "${var.tags_label_context}"
}
