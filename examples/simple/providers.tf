provider "aws" {
  region = "eu-central-1"
}

provider "snowflake" {
  preview_features_enabled = ["snowflake_system_get_privatelink_config_datasource"]
}
