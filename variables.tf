variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "context_templates" {
  description = "Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration"
  type        = map(string)
  default     = {}
}


variable "vpc_id" {
  description = "VPC ID where the AWS PrivateLink VPC Endpoint will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of AWS Subnet IDs where Snowflake AWS PrivateLink Endpoint interfaces will be created"
  type        = list(string)
}

variable "allow_vpc_cidr" {
  description = "Whether allow access to the Snowflake PrivateLink endpoint from the whole VPC"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "List of subnet CIDRs that will be allowed to access Snowflake endpoint via PrivateLink"
  type        = list(string)
  default     = []
}

variable "additional_dns_records" {
  description = "List of additional Route53 records to be added to local `privatelink.snowflakecomputing.com` hosted zone that points to Snowflake VPC endpoint."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for r in var.additional_dns_records : endswith(r, ".privatelink.snowflakecomputing.com")])
    error_message = "Each DNS record should be a subdomain of '.privatelink.snowflakecomputing.com'."
  }
}

variable "organization_name" {
  description = "Name of the organization, where the Snowflake account is created, used to create regionless privatelink fqdns"
  type        = string
  default     = null
}

variable "account_name" {
  description = "Name of the Snowflake account, used to create regionless privatelink fqdns"
  type        = string
  default     = null
}


variable "name_scheme" {
  description = <<EOT
  Naming scheme configuration for the resource. This configuration is used to generate names using context provider:
    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`
    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`
    - `context_template_name` - name of the context template used to create the name
    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name
    - `extra_values` - map of extra label-value pairs, used to create a name
    - `uppercase` - convert name to uppercase
  EOT
  type = object({
    properties            = optional(list(string), ["environment", "name"])
    delimiter             = optional(string, "_")
    context_template_name = optional(string, "snowflake-privatelink")
    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")
    extra_values          = optional(map(string))
    uppercase             = optional(bool, false)
  })
  default = {}
}
