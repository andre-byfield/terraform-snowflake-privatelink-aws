# Snowflake AWS PrivateLink Terraform Module

<!--- Pick Cloud provider Badge -->
<!---![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) -->
<!---![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white) -->
![Snowflake](https://img.shields.io/badge/-SNOWFLAKE-249edc?style=for-the-badge&logo=snowflake&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

<!--- Replace repository name -->
![License](https://badgen.net/github/license/getindata/terraform-snowflake-privatelink-aws/)
![Release](https://badgen.net/github/release/getindata/terraform-snowflake-privatelink-aws/)

<p align="center">
  <img height="150" src="https://getindata.com/img/logo.svg">
  <h3 align="center">We help companies turn their data into assets</h3>
</p>

---

Terraform module that can create and manage AWS PrivateLink for Snowflake.

This module creates:

* AWS VPC Endpoint
* Security group and assigns it to the endpoint
* AWS Route53 private zone and adds needed records inside

## USAGE

```terraform

module "snowflake_privatelink_aws" {
  source = "../../"

  name       = "snowflake"

  vpc_id     = "vpc-01234567890abcdef
  subnet_ids = ["subnet-01234567890abcdef", "subnet-01234567890abcdeg"]

  tags = {
    "example" = "tag"
  }
}

```

## NOTES

In order to successfully setup a PrivateLink in AWS - manual authorization of PrivateLink requests is needed,
more information can be found in Snowflake Documentation -
<https://docs.snowflake.com/en/user-guide/admin-security-privatelink.html#enabling-aws-privatelink>.

## Breaking changes in v2.x of the module

### Due to replacement of nulllabel (`context.tf`) with context provider, some **breaking changes** were introduced

List od code and variable (API) changes:

- Removed `context.tf` file (a single-file module with additonal variables), which implied a removal of all its variables (except `name`):
  - `descriptor_formats`
  - `label_value_case`
  - `label_key_case`
  - `id_length_limit`
  - `regex_replace_chars`
  - `label_order`
  - `additional_tag_map`
  - `tags`
  - `labels_as_tags`
  - `attributes`
  - `delimiter`
  - `stage`
  - `environment`
  - `tenant`
  - `namespace`
  - `enabled`
  - `context`
- Remove support `enabled` flag - that might cause some backward compatibility issues with terraform state (please take into account that proper `move` clauses were added to minimize the impact), but proceed with caution
- Additional `context` provider configuration
- New variables were added, to allow naming configuration via `context` provider:
  - `context_templates`
  - `name_schema`

### Due to rename of Snowflake terraform provider source, all `versions.tf` files were updated accordingly.

  Please keep in mind to mirror this change in your own repos also.

  For more information about provider rename, refer to [Snowflake documentation](https://github.com/snowflakedb/terraform-provider-snowflake/blob/main/SNOWFLAKEDB_MIGRATION.md).

### Maximal version of supported provider was unblocked

Keep in mind that, starting with Snowflake provider version `1.x`, the `snowflake_system_get_privatelink_config` resource is considered a preview feature and must be explicitly enabled in the provider configuration.

  **Required Provider Configuration:**

  ```terraform
  provider "snowflake" {
    preview_features_enabled = ["snowflake_system_get_privatelink_config_datasource"]
  }
  ```

  Without this configuration, you will encounter the following error:

  ```shell
  Error: snowflake_system_get_privatelink_config_datasource is currently a preview feature, and must be enabled by adding snowflake_system_get_privatelink_config_datasource to preview_features_enabled in Terraform configuration.
  ```

  For more information about preview features, refer to the [Snowflake provider documentation](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/stage#preview-features) and [Snowflake resource documentation](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/stage).

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | Name of the Snowflake account, used to create regionless privatelink fqdns | `string` | `null` | no |
| <a name="input_additional_dns_records"></a> [additional\_dns\_records](#input\_additional\_dns\_records) | List of additional Route53 records to be added to local `privatelink.snowflakecomputing.com` hosted zone that points to Snowflake VPC endpoint. | `list(string)` | `[]` | no |
| <a name="input_allow_vpc_cidr"></a> [allow\_vpc\_cidr](#input\_allow\_vpc\_cidr) | Whether allow access to the Snowflake PrivateLink endpoint from the whole VPC | `bool` | `true` | no |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of subnet CIDRs that will be allowed to access Snowflake endpoint via PrivateLink | `list(string)` | `[]` | no |
| <a name="input_context_templates"></a> [context\_templates](#input\_context\_templates) | Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `string` | n/a | yes |
| <a name="input_name_scheme"></a> [name\_scheme](#input\_name\_scheme) | Naming scheme configuration for the resource. This configuration is used to generate names using context provider:<br/>    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`<br/>    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`<br/>    - `context_template_name` - name of the context template used to create the name<br/>    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name<br/>    - `extra_values` - map of extra label-value pairs, used to create a name<br/>    - `uppercase` - convert name to uppercase | <pre>object({<br/>    properties            = optional(list(string), ["environment", "name"])<br/>    delimiter             = optional(string, "_")<br/>    context_template_name = optional(string, "snowflake-privatelink")<br/>    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")<br/>    extra_values          = optional(map(string))<br/>    uppercase             = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_organisation_name"></a> [organisation\_name](#input\_organisation\_name) | Name of the organisation, where the Snowflake account is created, used to create regionless privatelink fqdns | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of AWS Subnet IDs where Snowflake AWS PrivateLink Endpoint interfaces will be created | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the AWS PrivateLink VPC Endpoint will be created | `string` | n/a | yes |

## Modules

No modules.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_private_zone"></a> [dns\_private\_zone](#output\_dns\_private\_zone) | Details of Route53 private hosted zone created for Snowflake PrivateLink |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | Details of security group assigned to Snowflake AWS PrivateLink VPC Endpoint |
| <a name="output_snowflake_additional_dns_records"></a> [snowflake\_additional\_dns\_records](#output\_snowflake\_additional\_dns\_records) | List of additional DNS records added to `.privatelink.snowflakecomputing.com` hosted zone |
| <a name="output_snowflake_privatelink_ocsp_url"></a> [snowflake\_privatelink\_ocsp\_url](#output\_snowflake\_privatelink\_ocsp\_url) | URL to access Snowflake OCSP endpont using AWS PrivateLink |
| <a name="output_snowflake_privatelink_url"></a> [snowflake\_privatelink\_url](#output\_snowflake\_privatelink\_url) | URL to access Snowflake using AWS PrivateLink |
| <a name="output_snowflake_regionless_private_link_account_url"></a> [snowflake\_regionless\_private\_link\_account\_url](#output\_snowflake\_regionless\_private\_link\_account\_url) | URL to access Snowflake account using AWS PrivateLink without specifying AWS region |
| <a name="output_snowflake_regionless_private_link_snowsight_url"></a> [snowflake\_regionless\_private\_link\_snowsight\_url](#output\_snowflake\_regionless\_private\_link\_snowsight\_url) | URL to access Snowsight UI using AWS PrivateLink without specifying AWS region |
| <a name="output_vpc_endpoint"></a> [vpc\_endpoint](#output\_vpc\_endpoint) | Details created Snowflake AWS PrivateLink VPC Endpoint |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_context"></a> [context](#provider\_context) | >=0.4.0 |
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | >= 0.47 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_context"></a> [context](#requirement\_context) | >=0.4.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.47 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.snowflake_additional_dns_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.snowflake_private_link_ocsp_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.snowflake_private_link_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.snowflake_regionless_private_link_account_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.snowflake_regionless_private_link_snowsight_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [context_label.this](https://registry.terraform.io/providers/cloudposse/context/latest/docs/data-sources/label) | data source |
| [context_tags.this](https://registry.terraform.io/providers/cloudposse/context/latest/docs/data-sources/tags) | data source |
| [snowflake_system_get_privatelink_config.this](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/data-sources/system_get_privatelink_config) | data source |
<!-- END_TF_DOCS -->

## CONTRIBUTING

Contributions are very welcomed!

Start by reviewing [contribution guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md). After that, start coding and ship your changes by creating a new PR.

## LICENSE

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## AUTHORS

<!--- Replace repository name -->
<a href="https://github.com/getindata/snowflake-privatelink-aws/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=getindata/terraform-snowflake-privatelink-aws" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
