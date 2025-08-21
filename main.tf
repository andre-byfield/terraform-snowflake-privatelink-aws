data "context_label" "this" {
  delimiter  = local.context_template == null ? var.name_scheme.delimiter : null
  properties = local.context_template == null ? var.name_scheme.properties : null
  template   = local.context_template

  replace_chars_regex = var.name_scheme.replace_chars_regex

  values = merge(
    var.name_scheme.extra_values,
    { name = var.name }
  )
}

data "context_tags" "this" {}

data "snowflake_system_get_privatelink_config" "this" {}
moved {
  from = data.snowflake_system_get_privatelink_config.this[0]
  to   = data.snowflake_system_get_privatelink_config.this
}

data "aws_vpc" "this" {
  count = var.allow_vpc_cidr ? 1 : 0

  id = var.vpc_id
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  description = "Security group for Snowflake AWS PrivateLink VPC Endpoint"

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = local.allowed_cidrs
    protocol    = "tcp"
    description = "Allow HTTP ingress traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    cidr_blocks = local.allowed_cidrs
    protocol    = "tcp"
    description = "Allow HTTPS ingress traffic"
  }

  tags = data.context_tags.this.tags
}
moved {
  from = aws_security_group.this[0]
  to   = aws_security_group.this
}

resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = data.snowflake_system_get_privatelink_config.this.aws_vpce_id
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.this.id]
  subnet_ids          = var.subnet_ids
  private_dns_enabled = false

  tags = merge(data.context_tags.this.tags,
    {
      Name = var.name_scheme.uppercase ? upper(data.context_label.this.rendered) : data.context_label.this.rendered
    }
  )
}
moved {
  from = aws_vpc_endpoint.this[0]
  to   = aws_vpc_endpoint.this
}

resource "aws_route53_zone" "this" {
  name    = "privatelink.snowflakecomputing.com"
  comment = "Snowflake AWS PrivateLink records"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = data.context_tags.this.tags
}
moved {
  from = aws_route53_zone.this[0]
  to   = aws_route53_zone.this
}

resource "aws_route53_record" "snowflake_private_link_url" {
  zone_id = one(aws_route53_zone.this[*].zone_id)
  name    = data.snowflake_system_get_privatelink_config.this.account_url
  type    = "CNAME"
  ttl     = "300"
  records = [aws_vpc_endpoint.this.dns_entry[0]["dns_name"]]
}
moved {
  from = aws_route53_record.snowflake_private_link_url[0]
  to   = aws_route53_record.snowflake_private_link_url
}

resource "aws_route53_record" "snowflake_private_link_ocsp_url" {
  zone_id = aws_route53_zone.this.zone_id
  name    = data.snowflake_system_get_privatelink_config.this.ocsp_url
  type    = "CNAME"
  ttl     = "300"
  records = [aws_vpc_endpoint.this.dns_entry[0]["dns_name"]]
}
moved {
  from = aws_route53_record.snowflake_private_link_ocsp_url[0]
  to   = aws_route53_record.snowflake_private_link_ocsp_url
}

resource "aws_route53_record" "snowflake_regionless_private_link_account_url" {
  count = local.snowflake_account != null ? 1 : 0

  zone_id = one(aws_route53_zone.this[*].zone_id)
  name    = "${local.snowflake_account}.privatelink.snowflakecomputing.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_vpc_endpoint.this.dns_entry[0]["dns_name"]]
}

resource "aws_route53_record" "snowflake_regionless_private_link_snowsight_url" {
  count = local.snowflake_account != null ? 1 : 0

  zone_id = one(aws_route53_zone.this[*].zone_id)
  name    = "app-${local.snowflake_account}.privatelink.snowflakecomputing.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_vpc_endpoint.this.dns_entry[0]["dns_name"]]
}

resource "aws_route53_record" "snowflake_additional_dns_records" {
  for_each = toset(var.additional_dns_records)

  zone_id = one(aws_route53_zone.this[*].zone_id)
  name    = each.key
  type    = "CNAME"
  ttl     = "300"
  records = [aws_vpc_endpoint.this.dns_entry[0]["dns_name"]]
}
