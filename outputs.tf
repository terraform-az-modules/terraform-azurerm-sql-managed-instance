output "mssql_managed_instance_id" {
  description = "The SQL Managed Instance ID."
  value       = try(azurerm_mssql_managed_instance.main[0].id, null)
}

output "mssql_managed_instance_dns_zone" {
  description = "The Dns Zone where the SQL Managed Instance is located."
  value       = try(azurerm_mssql_managed_instance.main[0].dns_zone, null)
}

output "mssql_managed_instance_fqdn" {
  description = "The fully qualified domain name of the Azure Managed SQL Instance."
  value       = try(azurerm_mssql_managed_instance.main[0].fqdn, null)
}

output "mssql_managed_database_id" {
  description = "The ID of the SQL Managed Database."
  value       = try(azurerm_mssql_managed_database.main[0].id, null)
}

output "mssql_failover_group_id" {
  description = "The ID of the Managed Instance Failover Group."
  value       = try(azurerm_mssql_managed_instance_failover_group.main[0].id, null)
}

output "mssql_failover_group_partner_region" {
  description = "The partner region block."
  value       = try(azurerm_mssql_managed_instance_failover_group.main[0].partner_region, null)
}

output "mssql_failover_group_role" {
  description = "The local replication role of the Managed Instance Failover Group."
  value       = try(azurerm_mssql_managed_instance_failover_group.main[0].role, null)
}

output "mssql_security_alert_policy_id" {
  description = "The ID of the MS SQL Managed Instance Security Alert Policy."
  value       = try(azurerm_mssql_managed_instance_security_alert_policy.main[0].id, null)
}

output "mssql_start_stop_schedule_id" {
  description = "The ID of the MS SQL Managed Instance Start Stop Schedule."
  value       = try(azurerm_mssql_managed_instance_start_stop_schedule.main[0].id, null)
}

output "mssql_start_stop_schedule_next_execution_time" {
  description = "Timestamp when the next action will be executed in the corresponding schedule time zone."
  value       = try(azurerm_mssql_managed_instance_start_stop_schedule.main[0].next_execution_time, null)
}

output "mssql_start_stop_schedule_next_run_action" {
  description = "Next action to be executed (Start or Stop)."
  value       = try(azurerm_mssql_managed_instance_start_stop_schedule.main[0].next_run_action, null)
}

output "mssql_vulnerability_assessment_id" {
  description = "The ID of the Vulnerability Assessment."
  value       = try(azurerm_mssql_managed_instance_vulnerability_assessment.main[0].id, null)
}

output "mssql_transparent_data_encryption_id" {
  description = "The ID of the MSSQL encryption protector."
  value       = try(azurerm_mssql_managed_instance_transparent_data_encryption.main[0].id, null)
}