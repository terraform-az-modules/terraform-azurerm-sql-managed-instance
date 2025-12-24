##-----------------------------------------------------------------------------
# Global
##-----------------------------------------------------------------------------

variable "enabled" {
  type        = bool
  default     = true
  description = "Enable or disable creation of all SQL Managed Instance resources."
}

variable "name" {
  type        = string
  description = "Base name for resources."
}

variable "custom_name" {
  type        = string
  default     = null
  description = "Optional custom name to override the base name in tags."
}

variable "location" {
  type        = string
  default     = null
  description = "Azure region where resources will be deployed."
}

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment (e.g., dev, stage, prod)."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group where resources will be deployed."
}

variable "managedby" {
  type        = string
  default     = "terraform"
  description = "Tag to indicate the tool or team managing the resources."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azurerm-sql-managed-instance.git"
  description = "Repository URL or identifier for traceability."
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Deployment mode identifier (e.g., blue/green, canary)."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment", "location"]
  description = "Order of labels to be used in naming/tagging."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to all resources."
}

variable "resource_position_prefix" {
  type        = bool
  default     = false
  description = "If true, prefixes resource names instead of suffixing."
}

##-----------------------------------------------------------------------------
# MSSQL Managed Instance
##-----------------------------------------------------------------------------

variable "license_type" {
  type        = string
  default     = "LicenseIncluded"
  description = "License type for the SQL Managed Instance."

  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.license_type)
    error_message = "license_type must be either LicenseIncluded or BasePrice."
  }
}

variable "sku_name" {
  type        = string
  default     = "GP_Gen5"
  description = "SKU name for the SQL Managed Instance."
}

variable "storage_size_in_gb" {
  type        = number
  default     = 32
  description = "Maximum storage size in GB (must be a multiple of 32)."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID where the SQL Managed Instance will be deployed."
}

variable "vcores" {
  type        = number
  default     = 4
  description = "Number of vCores for the SQL Managed Instance."
}

variable "collation" {
  type        = string
  default     = null
  description = "SQL collation for the Managed Instance."
}

variable "database_format" {
  type        = string
  default     = null
  description = "Database internal format."

  validation {
    condition     = var.database_format == null || contains(["AlwaysUpToDate", "SQLServer2022"], var.database_format)
    error_message = "database_format must be AlwaysUpToDate or SQLServer2022."
  }
}

variable "dns_zone_partner_id" {
  type        = string
  default     = null
  description = "DNS zone partner managed instance ID."
}

variable "hybrid_secondary_usage" {
  type        = string
  default     = null
  description = "Hybrid secondary usage mode."

  validation {
    condition     = var.hybrid_secondary_usage == null || contains(["Active", "Passive"], var.hybrid_secondary_usage)
    error_message = "hybrid_secondary_usage must be Active or Passive."
  }
}

variable "maintenance_configuration_name" {
  type        = string
  default     = null
  description = "Maintenance configuration name."
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "Minimum TLS version."

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be 1.0, 1.1, or 1.2."
  }
}

variable "proxy_override" {
  type        = string
  default     = null
  description = "Proxy override mode."

  validation {
    condition     = var.proxy_override == null || contains(["Default", "Proxy", "Redirect"], var.proxy_override)
    error_message = "proxy_override must be Default, Proxy, or Redirect."
  }
}

variable "public_data_endpoint_enabled" {
  type        = bool
  default     = false
  description = "Enable public data endpoint for the SQL Managed Instance."
}

variable "service_principal_type" {
  type        = string
  default     = null
  description = "Service principal type."

  validation {
    condition     = var.service_principal_type == null || var.service_principal_type == "SystemAssigned"
    error_message = "service_principal_type can only be SystemAssigned."
  }
}

variable "storage_account_type" {
  type        = string
  default     = "LRS"
  description = "Backup storage account type."

  validation {
    condition     = contains(["GRS", "GZRS", "LRS", "ZRS"], var.storage_account_type)
    error_message = "storage_account_type must be GRS, GZRS, LRS, or ZRS."
  }
}

variable "zone_redundant_enabled" {
  type        = bool
  default     = false
  description = "Enable zone redundancy for the SQL Managed Instance."
}

variable "timezone_id" {
  type        = string
  default     = "UTC"
  description = "Timezone ID for the SQL Managed Instance."
}

variable "secondary_location" {
  description = "Azure region for secondary SQL Managed Instance (must be different from primary)"
  type        = string
  default     = null
}

variable "secondary_subnet_id" {
  description = "Subnet ID for secondary SQL Managed Instance"
  type        = string
  default     = null
}

variable "secondary_resource_group_name" {
  description = "Resource group name for secondary instance (optional, defaults to primary RG)"
  type        = string
  default     = null
}

##-----------------------------------------------------------------------------
# Authentication
##-----------------------------------------------------------------------------

variable "administrator_login" {
  type        = string
  default     = "sqladmin"
  description = "Administrator login name for SQL authentication (required if Azure AD admin is not configured)."
}

variable "administrator_login_password" {
  type        = string
  default     = null
  description = "Administrator password for SQL authentication (required if Azure AD admin is not configured)."
  sensitive   = true
}

variable "azure_active_directory_administrator" {
  description = "Azure Active Directory administrator configuration."
  type = object({
    login_username                      = string
    object_id                           = string
    principal_type                      = string
    azuread_authentication_only_enabled = optional(bool, false)
    tenant_id                           = optional(string)
  })
  default = null
}

variable "identity" {
  description = "Managed identity configuration."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

##-----------------------------------------------------------------------------
# MSSQL Managed Database
##-----------------------------------------------------------------------------

variable "short_term_retention_days" {
  type        = number
  default     = 7
  description = "Number of days to retain short-term backups for the SQL Managed Instance."
}

variable "long_term_retention_policy" {
  description = "Long-term backup retention policy for the SQL Managed Instance database."
  type = object({
    monthly_retention = optional(string)
    week_of_year      = optional(number)
    weekly_retention  = optional(string)
    yearly_retention  = optional(string)
  })
  default = null
}

variable "point_in_time_restore" {
  description = "Point-in-time restore configuration for the SQL Managed Instance database."
  type = object({
    restore_point_in_time = string
    source_database_id    = string
  })
  default = null
}

##-----------------------------------------------------------------------------
# Failover group
##-----------------------------------------------------------------------------

variable "failover_enabled" {
  type        = bool
  default     = false
  description = "Enable failover group for the SQL Managed Instance."
}

variable "partner_managed_instance_id" {
  type        = string
  default     = null
  description = "The ID of the partner SQL Managed Instance used for failover groups."
}

variable "readonly_endpoint_failover_policy_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether the read-only endpoint failover policy is enabled."
}

variable "read_write_endpoint_failover_policy" {
  description = "Read-write endpoint failover policy configuration."
  type = object({
    mode          = string
    grace_minutes = number
  })
  default = null
}

##-----------------------------------------------------------------------------
# Security alert policy
##-----------------------------------------------------------------------------

variable "security_alert_policy_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the security alert policy is enabled."
}

variable "disabled_alerts" {
  type        = list(string)
  default     = []
  description = "List of disabled security alerts."
}

variable "email_account_admins_enabled" {
  type        = bool
  default     = false
  description = "Whether alerts are sent to account administrators."
}

variable "email_addresses" {
  type        = list(string)
  default     = []
  description = "Email addresses that receive security alerts."
}

variable "retention_days" {
  type        = number
  default     = 0
  description = "Number of days to retain threat detection audit logs."
}

variable "storage_endpoint" {
  type        = string
  default     = null
  description = "Blob storage endpoint used to store threat detection audit logs."
}

variable "storage_account_access_key" {
  type        = string
  default     = null
  sensitive   = true
  description = "Access key for the storage account used for audit logs."
}

##-----------------------------------------------------------------------------
# Start/stop schedule
##-----------------------------------------------------------------------------

variable "enable_start_stop_schedule" {
  type        = bool
  default     = false
  description = "Enable start/stop schedule for the SQL Managed Instance."
}

variable "start_stop_timezone_id" {
  type        = string
  default     = "UTC"
  description = "Timezone ID used for the start/stop schedule."
}

variable "start_stop_schedules" {
  description = "Start/stop schedule configuration for the SQL Managed Instance."
  type = object({
    start_day  = string
    start_time = string # HH:MM
    stop_day   = string
    stop_time  = string # HH:MM
  })
  default = null
}

##-----------------------------------------------------------------------------
# Vulnerability assessment
##-----------------------------------------------------------------------------

variable "vulnerability_assessment_enabled" {
  type        = bool
  default     = false
  description = "Enable vulnerability assessment for the SQL Managed Instance."
}

variable "va_storage_container_path" {
  type        = string
  default     = null
  description = "Storage container path for vulnerability assessment (e.g., https://account.blob.core.windows.net/container/)."
}

variable "va_storage_account_access_key" {
  type        = string
  default     = null
  sensitive   = true
  description = "Storage account access key used to write vulnerability assessment results."
}

variable "va_recurring_scans" {
  description = "Recurring scans configuration for vulnerability assessment."
  type = object({
    enabled                   = bool
    email_subscription_admins = bool
    emails                    = list(string)
  })
  default = null
}

##-----------------------------------------------------------------------------
# Key Vault / CMK
##-----------------------------------------------------------------------------

variable "key_vault_id" {
  type        = string
  default     = null
  description = "ID of the Azure Key Vault used for customer-managed keys and secrets."
}

variable "rotation_policy_config" {
  type = object({
    enabled              = bool
    time_before_expiry   = optional(string, null)
    expire_after         = optional(string, null)
    notify_before_expiry = optional(string, null)
  })
  default = {
    enabled              = true
    time_before_expiry   = "P30D"
    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
  description = "Rotation policy configuration for keys stored in Key Vault (ISO 8601 duration format, for example P30D)."
}

variable "key_permissions" {
  type        = list(string)
  default     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  description = "Key permissions to assign in Key Vault access policy or RBAC for this key."
}

variable "key_vault_rbac_auth_enabled" {
  type        = bool
  default     = true
  description = "Enable role-based access control (RBAC) for authenticating to Key Vault instead of access policies."
}

variable "key_expiration_date" {
  description = "Expiration date for the Key Vault key in ISO 8601 format (for example 2028-12-31T23:59:59Z)."
  type        = string
  default     = null
}

variable "key_type" {
  description = "Key type to create in Key Vault (for example RSA or RSA-HSM)."
  type        = string
  default     = "RSA-HSM"
}

variable "key_size" {
  description = "Size of the RSA key in bits (for example 2048, 3072, 4096)."
  type        = number
  default     = 2048
}

variable "encryption" {
  type        = bool
  default     = true
  description = "Enable customer-managed encryption for the SQL Managed Instance using Key Vault."
}

##-----------------------------------------------------------------------------
# Private Endpoint & DNS
##-----------------------------------------------------------------------------

variable "enable_private_endpoint" {
  type        = bool
  default     = true
  description = "Enable private endpoint for the SQL Managed Instance."
}

variable "private_dns_zone_ids" {
  type        = string
  default     = null
  description = "The ID of the private DNS zone associated with the SQL Managed Instance private endpoint."
}

variable "manual_connection" {
  description = "Indicates whether the connection is manual"
  type        = bool
  default     = false
}

variable "endpoint_subnet_id" {
  type        = string
  description = "Subnet ID for Private Endpoint (must be non-delegated subnet)"
}

##-----------------------------------------------------------------------------
## Diagnostic Settings & Monitoring
##-----------------------------------------------------------------------------

variable "enable_diagnostic" {
  type        = bool
  default     = true
  description = "Enable diagnostic settings for ACR."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Log Analytics Workspace ID for diagnostics."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "Storage account ID for diagnostic settings destination."
}

variable "metric_enabled" {
  type        = bool
  default     = true
  description = "Boolean flag to specify whether Metrics should be enabled for the Container Registry. Defaults to true."
}

variable "logs" {
  type = list(object({
    category_group = optional(string)
    category       = optional(string)
  }))
  default     = []
  description = "List of log configurations for diagnostic settings. Each object can specify either category_group or category."
}