provider "aws" {
  region = "us-east-1"
}

provider "snowflake" {
  organization_name = var.snowflake_organization_name
  account_name      = var.snowflake_account_name
  user              = var.user
  role              = "ACCOUNTADMIN"
  authenticator     = var.authenticator
  private_key       = file(var.private_key_path)
  private_key_passphrase  = var.private_key_passphrase
  preview_features_enabled = ["snowflake_system_get_privatelink_config_datasource"]
}
