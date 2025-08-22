output "vpc_endpoint" {
  description = "Details created Snowflake AWS PrivateLink VPC Endpoint"
  value = {
    arn                = resource.aws_vpc_endpoint.this.arn
    dns_entry          = resource.aws_vpc_endpoint.this.dns_entry
    id                 = resource.aws_vpc_endpoint.this.id
    security_group_ids = resource.aws_vpc_endpoint.this.security_group_ids
    service_name       = resource.aws_vpc_endpoint.this.service_name
    subnet_ids         = resource.aws_vpc_endpoint.this.subnet_ids
    state              = resource.aws_vpc_endpoint.this.state
    vpc_id             = resource.aws_vpc_endpoint.this.vpc_id
    vpc_endpoint_type  = resource.aws_vpc_endpoint.this.vpc_endpoint_type

  }
}

output "security_group" {
  description = "Details of security group assigned to Snowflake AWS PrivateLink VPC Endpoint"
  value = {
    arn     = resource.aws_security_group.this.arn
    id      = resource.aws_security_group.this.id
    egress  = resource.aws_security_group.this.egress
    ingress = resource.aws_security_group.this.ingress
  }
}

output "dns_private_zone" {
  description = "Details of Route53 private hosted zone created for Snowflake PrivateLink"
  value = {
    arn     = resource.aws_route53_zone.this.arn
    zone_id = resource.aws_route53_zone.this.zone_id
    name    = resource.aws_route53_zone.this.name
  }
}

output "snowflake_privatelink_url" {
  description = "URL to access Snowflake using AWS PrivateLink"
  value = {
    fqdn = resource.aws_route53_record.snowflake_private_link_url.fqdn
    url  = "https://${resource.aws_route53_record.snowflake_private_link_url.fqdn}"
  }
}

output "snowflake_privatelink_ocsp_url" {
  description = "URL to access Snowflake OCSP endpont using AWS PrivateLink"
  value = {
    fqdn = resource.aws_route53_record.snowflake_private_link_ocsp_url.fqdn
  }
}

output "snowflake_regionless_private_link_account_url" {
  description = "URL to access Snowflake account using AWS PrivateLink without specifying AWS region"
  value = {
    fqdn = one(resource.aws_route53_record.snowflake_regionless_private_link_account_url[*].fqdn)
    url  = local.snowflake_account != null ? "https://${one(resource.aws_route53_record.snowflake_regionless_private_link_account_url[*].fqdn)}" : null
  }
}

output "snowflake_regionless_private_link_snowsight_url" {
  description = "URL to access Snowsight UI using AWS PrivateLink without specifying AWS region"
  value = {
    fqdn = one(resource.aws_route53_record.snowflake_regionless_private_link_snowsight_url[*].fqdn)
    url  = local.snowflake_account != null ? "https://${one(resource.aws_route53_record.snowflake_regionless_private_link_snowsight_url[*].fqdn)}" : null
  }
}

output "snowflake_additional_dns_records" {
  description = "List of additional DNS records added to `.privatelink.snowflakecomputing.com` hosted zone"
  value       = [for r in resource.aws_route53_record.snowflake_additional_dns_records : r.fqdn]
}
