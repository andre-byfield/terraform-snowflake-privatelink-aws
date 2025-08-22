<!-- BEGIN_TF_DOCS -->
# Complete example of Snowflake PrivateLink AWS

This is a complete example of Snowflake PrivateLink AWS module usage

This example:

* Creates AWS VPC
* Creates AWS Subnet
* Creates `snowflake_privatelink_aws` module, which:
  * Creates AWS VPC Endpoint
  * Creates Security group and assigns it to the endpoint
  * AWS Route53 private zone and creates needed records inside



## Inputs

No inputs.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_snowflake_privatelink_aws"></a> [snowflake\_privatelink\_aws](#module\_snowflake\_privatelink\_aws) | ../../ | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_privatelink_details"></a> [privatelink\_details](#output\_privatelink\_details) | Details of Snowflake AWS PrivateLink |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

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
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_route53_query_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_query_log) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
<!-- END_TF_DOCS -->
