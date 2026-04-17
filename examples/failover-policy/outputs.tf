##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------

output "mssql_managed_instance_id" {
  description = "The SQL Managed Instance ID."
  value       = module.sql_instance.mssql_managed_instance_id
}

output "mssql_managed_instance_dns_zone" {
  description = "The DNS Zone where the SQL Managed Instance is located."
  value       = module.sql_instance.mssql_managed_instance_dns_zone
}

output "mssql_managed_instance_fqdn" {
  description = "The fully qualified domain name of the Azure Managed SQL Instance."
  value       = module.sql_instance.mssql_managed_instance_fqdn
}

output "mssql_managed_database_id" {
  description = "The ID of the SQL Managed Database."
  value       = module.sql_instance.mssql_managed_database_id
}

output "mssql_failover_group_id" {
  description = "The ID of the Managed Instance Failover Group."
  value       = module.sql_instance.mssql_failover_group_id
}

output "mssql_failover_group_partner_region" {
  description = "The partner region block."
  value       = module.sql_instance.mssql_failover_group_partner_region
}

output "mssql_failover_group_role" {
  description = "The local replication role of the Managed Instance Failover Group."
  value       = module.sql_instance.mssql_failover_group_role
}

output "mssql_security_alert_policy_id" {
  description = "The ID of the MS SQL Managed Instance Security Alert Policy."
  value       = module.sql_instance.mssql_security_alert_policy_id
}

output "mssql_start_stop_schedule_id" {
  description = "The ID of the MS SQL Managed Instance Start Stop Schedule."
  value       = module.sql_instance.mssql_start_stop_schedule_id
}

output "mssql_start_stop_schedule_next_execution_time" {
  description = "Timestamp when the next action will be executed in the corresponding schedule time zone."
  value       = module.sql_instance.mssql_start_stop_schedule_next_execution_time
}

output "mssql_start_stop_schedule_next_run_action" {
  description = "Next action to be executed (Start or Stop)."
  value       = module.sql_instance.mssql_start_stop_schedule_next_run_action
}

output "mssql_vulnerability_assessment_id" {
  description = "The ID of the Vulnerability Assessment."
  value       = module.sql_instance.mssql_vulnerability_assessment_id
}
