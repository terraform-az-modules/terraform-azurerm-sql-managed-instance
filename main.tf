##-----------------------------------------------------------------------------
# Standard Tagging Module – Applies standard tags to all resources for traceability
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azurerm"
  version         = "1.0.2"
  name            = var.custom_name == null ? var.name : var.custom_name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

resource "random_password" "sql_admin" {
  length           = 24
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "!@#$%^&*()-_=+[]{}"
}


##-----------------------------------------------------------------------------
# MSSQL Managed Instance
##-----------------------------------------------------------------------------
resource "azurerm_mssql_managed_instance" "main" {
  count                          = var.enabled ? 1 : 0
  name                           = var.resource_position_prefix ? format("sqlmi-%s", local.name) : format("%s-sqlmi", local.name)
  resource_group_name            = var.resource_group_name
  location                       = var.location
  license_type                   = var.license_type
  sku_name                       = var.sku_name
  storage_size_in_gb             = var.storage_size_in_gb
  subnet_id                      = var.subnet_id
  vcores                         = var.vcores
  administrator_login            = var.azure_active_directory_administrator == null ? var.administrator_login : null
  administrator_login_password   = var.azure_active_directory_administrator == null ? (var.administrator_login_password != null ? var.administrator_login_password : random_password.sql_admin.result) : null
  collation                      = var.collation
  database_format                = var.database_format
  dns_zone_partner_id            = var.dns_zone_partner_id
  hybrid_secondary_usage         = var.hybrid_secondary_usage
  maintenance_configuration_name = var.maintenance_configuration_name
  minimum_tls_version            = var.minimum_tls_version
  proxy_override                 = var.proxy_override
  public_data_endpoint_enabled   = var.public_data_endpoint_enabled
  service_principal_type         = var.service_principal_type
  storage_account_type           = var.storage_account_type
  zone_redundant_enabled         = var.zone_redundant_enabled
  timezone_id                    = var.timezone_id
  tags                           = module.labels.tags
  dynamic "azure_active_directory_administrator" {
    for_each = var.azure_active_directory_administrator == null ? [] : [var.azure_active_directory_administrator]
    content {
      login_username                      = azure_active_directory_administrator.value.login_username
      object_id                           = azure_active_directory_administrator.value.object_id
      principal_type                      = azure_active_directory_administrator.value.principal_type
      azuread_authentication_only_enabled = azure_active_directory_administrator.value.azuread_authentication_only_enabled
      tenant_id                           = azure_active_directory_administrator.value.tenant_id
    }
  }
  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

resource "azurerm_mssql_managed_instance" "secondary" {
  count                          = var.enabled && var.failover_enabled ? 1 : 0
  name                           = var.resource_position_prefix ? format("sqlmi-%s-secondary", local.name) : format("%s-sqlmi-secondary", local.name)
  resource_group_name            = var.secondary_resource_group_name != null ? var.secondary_resource_group_name : var.resource_group_name
  location                       = var.secondary_location
  license_type                   = var.license_type
  sku_name                       = var.sku_name
  storage_size_in_gb             = var.storage_size_in_gb
  subnet_id                      = var.secondary_subnet_id
  vcores                         = var.vcores
  administrator_login            = var.azure_active_directory_administrator == null ? var.administrator_login : null
  administrator_login_password   = var.azure_active_directory_administrator == null ? (var.administrator_login_password != null ? var.administrator_login_password : random_password.sql_admin.result) : null
  collation                      = var.collation
  database_format                = var.database_format
  dns_zone_partner_id            = azurerm_mssql_managed_instance.main[0].id
  hybrid_secondary_usage         = var.hybrid_secondary_usage
  maintenance_configuration_name = var.maintenance_configuration_name
  minimum_tls_version            = var.minimum_tls_version
  proxy_override                 = var.proxy_override
  public_data_endpoint_enabled   = var.public_data_endpoint_enabled
  service_principal_type         = var.service_principal_type
  storage_account_type           = var.storage_account_type
  zone_redundant_enabled         = var.zone_redundant_enabled
  timezone_id                    = var.timezone_id
  tags                           = module.labels.tags
  dynamic "azure_active_directory_administrator" {
    for_each = var.azure_active_directory_administrator == null ? [] : [var.azure_active_directory_administrator]
    content {
      login_username                      = azure_active_directory_administrator.value.login_username
      object_id                           = azure_active_directory_administrator.value.object_id
      principal_type                      = azure_active_directory_administrator.value.principal_type
      azuread_authentication_only_enabled = azure_active_directory_administrator.value.azuread_authentication_only_enabled
      tenant_id                           = azure_active_directory_administrator.value.tenant_id
    }
  }
  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  depends_on = [azurerm_mssql_managed_instance.main]
}
##-----------------------------------------------------------------------------
# MSSQL Managed Database
##-----------------------------------------------------------------------------
resource "azurerm_mssql_managed_database" "main" {
  count                     = var.enabled ? 1 : 0
  managed_instance_id       = azurerm_mssql_managed_instance.main[0].id
  name                      = var.resource_position_prefix ? format("mysql-db-%s", local.name) : format("%s-mysql-db", local.name)
  short_term_retention_days = var.short_term_retention_days
  tags                      = module.labels.tags
  dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention_policy == null ? [] : [var.long_term_retention_policy]
    content {
      monthly_retention = long_term_retention_policy.value.monthly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
    }
  }
  dynamic "point_in_time_restore" {
    for_each = var.point_in_time_restore == null ? [] : [var.point_in_time_restore]
    content {
      restore_point_in_time = point_in_time_restore.value.restore_point_in_time
      source_database_id    = point_in_time_restore.value.source_database_id
    }
  }
}

##-----------------------------------------------------------------------------
# MSSQL Managed Instance Failover Group
##-----------------------------------------------------------------------------
resource "azurerm_mssql_managed_instance_failover_group" "main" {
  count                                     = var.enabled && var.failover_enabled ? 1 : 0
  location                                  = var.location
  managed_instance_id                       = azurerm_mssql_managed_instance.main[0].id
  name                                      = var.resource_position_prefix ? format("failover-grp-%s", local.name) : format("%s-failover-grp", local.name)
  partner_managed_instance_id               = var.failover_enabled ? azurerm_mssql_managed_instance.secondary[0].id : var.partner_managed_instance_id
  readonly_endpoint_failover_policy_enabled = var.readonly_endpoint_failover_policy_enabled
  secondary_type                            = "Geo"
  dynamic "read_write_endpoint_failover_policy" {
    for_each = var.read_write_endpoint_failover_policy == null ? [] : [var.read_write_endpoint_failover_policy]
    content {
      mode          = read_write_endpoint_failover_policy.value.mode
      grace_minutes = read_write_endpoint_failover_policy.value.grace_minutes
    }
  }
}

##-----------------------------------------------------------------------------
# MSSQL Managed Instance Security Alert Policy
##-----------------------------------------------------------------------------
resource "azurerm_mssql_managed_instance_security_alert_policy" "main" {
  count                        = var.enabled && var.security_alert_policy_enabled ? 1 : 0
  resource_group_name          = var.resource_group_name
  managed_instance_name        = azurerm_mssql_managed_instance.main[0].name
  enabled                      = var.security_alert_policy_enabled
  disabled_alerts              = var.disabled_alerts
  email_account_admins_enabled = var.email_account_admins_enabled
  email_addresses              = var.email_addresses
  retention_days               = var.retention_days
  storage_endpoint             = var.storage_endpoint
  storage_account_access_key   = var.storage_account_access_key
}

##-----------------------------------------------------------------------------
# MSSQL Managed Instance Start Stop Schedule
##-----------------------------------------------------------------------------
resource "azurerm_mssql_managed_instance_start_stop_schedule" "main" {
  count               = var.enabled && var.enable_start_stop_schedule ? 1 : 0
  managed_instance_id = azurerm_mssql_managed_instance.main[0].id
  timezone_id         = var.start_stop_timezone_id
  dynamic "schedule" {
    for_each = var.start_stop_schedules == null ? [] : [var.start_stop_schedules]
    content {
      start_day  = schedule.value.start_day
      start_time = schedule.value.start_time
      stop_day   = schedule.value.stop_day
      stop_time  = schedule.value.stop_time
    }
  }
}

##-----------------------------------------------------------------------------
# MSSQL Managed Instance Vulnerability Assessment
##-----------------------------------------------------------------------------
resource "azurerm_mssql_managed_instance_vulnerability_assessment" "main" {
  depends_on                 = [azurerm_mssql_managed_instance_security_alert_policy.main]
  count                      = var.enabled && var.vulnerability_assessment_enabled ? 1 : 0
  managed_instance_id        = azurerm_mssql_managed_instance.main[0].id
  storage_container_path     = var.va_storage_container_path
  storage_account_access_key = var.va_storage_account_access_key
  dynamic "recurring_scans" {
    for_each = var.va_recurring_scans == null ? [] : [var.va_recurring_scans]
    content {
      enabled                   = recurring_scans.value.enabled
      email_subscription_admins = recurring_scans.value.email_subscription_admins
      emails                    = recurring_scans.value.emails
    }
  }
}

##-----------------------------------------------------------------------------
## Key Vault Key - Deploy encryption key for SQL Managed Instance content
##-----------------------------------------------------------------------------
resource "azurerm_key_vault_key" "main" {
  depends_on      = [azurerm_role_assignment.identity_assigned]
  count           = var.enabled && var.encryption ? 1 : 0
  name            = var.resource_position_prefix ? format("cmk-key-sqlmi-%s", local.name) : format("%s-cmk-key-sqlmi", local.name)
  key_vault_id    = var.key_vault_id
  key_type        = var.key_type
  key_size        = var.key_size
  expiration_date = var.key_expiration_date
  key_opts        = var.key_permissions
  dynamic "rotation_policy" {
    for_each = var.rotation_policy_config.enabled ? [1] : []
    content {
      automatic {
        time_before_expiry = var.rotation_policy_config.time_before_expiry
      }
      expire_after         = var.rotation_policy_config.expire_after
      notify_before_expiry = var.rotation_policy_config.notify_before_expiry
    }
  }
}

##-----------------------------------------------------------------------------
## Managed Identity - Deploy user-assigned identity for SQL Managed Instance encryption
##-----------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "identity" {
  count               = var.enabled && var.encryption != null ? 1 : 0
  location            = var.location
  name                = var.resource_position_prefix ? format("mid-sqlmi-%s", local.name) : format("%s-mid-sqlmi", local.name)
  resource_group_name = var.resource_group_name
}

#-----------------------------------------------------------------------------
## Private Endpoint - Deploy private network access to SQL Managed Instance
##-----------------------------------------------------------------------------
resource "azurerm_private_endpoint" "main" {
  count                         = var.enabled && var.enable_private_endpoint ? 1 : 0
  name                          = var.resource_position_prefix ? format("pe-sqlmi-%s", local.name) : format("%s-pe-sqlmi", local.name)
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.endpoint_subnet_id
  custom_network_interface_name = var.resource_position_prefix ? format("pe-nic-sqlmi-%s", local.name) : format("%s-pe-nic-sqlmi", local.name)
  private_dns_zone_group {
    name                 = var.resource_position_prefix ? format("dns-zone-group-sqlmi-%s", local.name) : format("%s-dns-zone-group-sqlmi", local.name)
    private_dns_zone_ids = [var.private_dns_zone_ids]
  }
  private_service_connection {
    name                           = var.resource_position_prefix ? format("psc-sqlmi-%s", local.name) : format("%s-psc-sqlmi", local.name)
    is_manual_connection           = var.manual_connection
    private_connection_resource_id = azurerm_mssql_managed_instance.main[0].id
    subresource_names              = ["managedInstance"]
  }
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

##----------------------------------------------------------------------------
## Transparent Data Encryption
##----------------------------------------------------------------------------

resource "azurerm_mssql_managed_instance_transparent_data_encryption" "main" {
  count                 = var.enabled && var.enable_transparent_data_encryption ? 1 : 0
  managed_instance_id   = azurerm_mssql_managed_instance.main[0].id
  key_vault_key_id      = azurerm_key_vault_key.main[0].id
  managed_hsm_key_id    = var.managed_hsm_key_id
  auto_rotation_enabled = var.auto_rotation_enabled
  depends_on            = [azurerm_key_vault_key.main, azurerm_mssql_managed_instance.main]
}

##-----------------------------------------------------------------------------
## Diagnostic Setting - Deploy monitoring and logging for SQL Managed Instance
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "sqlmi-diag" {
  count                      = var.enabled && var.enable_diagnostic ? 1 : 0
  name                       = var.resource_position_prefix ? format("nic-diag-log-sqlmi-%s", local.name) : format("%s-nic-diag-log-sqlmi", local.name)
  target_resource_id         = azurerm_mssql_managed_instance.main[0].id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  dynamic "enabled_log" {
    for_each = var.logs
    content {
      category_group = lookup(enabled_log.value, "category_group", null)
      category       = lookup(enabled_log.value, "category", null)
    }
  }
  dynamic "enabled_metric" {
    for_each = var.metric_enabled ? ["AllMetrics"] : []
    content {
      category = enabled_metric.value
    }
  }
}