locals {
  context_template = lookup(var.context_templates, var.name_scheme.context_template_name, null)

  allowed_cidrs = concat(
    var.allow_vpc_cidr ? [one(data.aws_vpc.this).cidr_block] : [],
    var.allowed_cidrs
  )

  snowflake_account = var.organization_name != null && var.account_name != null ? "${var.organization_name}-${var.account_name}" : null
}
