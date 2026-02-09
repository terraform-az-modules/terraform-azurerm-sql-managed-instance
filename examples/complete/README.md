<!-- BEGIN_TF_DOCS -->

# Azure MSSQL Managed Instance

This example demonstrates how to deploy an Azure SQL Managed Instance with a complete infrastructure setup including virtual network, subnets, security groups, Key Vault, private DNS zones, and Log Analytics workspace.


---

## ✅ Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.6.6  |
| Azurerm   | >= 3.116.0 |

---

## 🔌 Providers

_No providers are explicitly defined in this example._

---

## 📦 Modules

| Name               | Source                                                                                | Version |
| ------------------ | ------------------------------------------------------------------------------------- | ------- |
| `resource_group`   | terraform-az-modules/resource-group/azure                                             | 1.0.3   |
| `vnet`             | terraform-az-modules/vnet/azure                                                       | 1.0.3   |
| `subnet`           | terraform-az-modules/subnet/azure                                                     | 1.0.1   |
| `security_group`   | terraform-az-modules/nsg/azure                                                        | 1.0.2   |
| `log-analytics`    | terraform-az-modules/log-analytics/azure                                              | 1.0.2   |
| `key_vault`        | terraform-az-modules/key-vault/azure                                                  | 1.0.4   |
| `private_dns_zone` | terraform-az-modules/private-dns/azure                                                | 1.0.4   |
| `virtual-machine`  | `../../`                                                                              | n/a     |


---

## 🏗️ Resources

_No standalone resources are declared in this example._

---

## 🔧 Inputs

_No input variables are defined in this example._

---

## 📤 Outputs


| Name | Description |
|------|-------------|
| `mssql_managed_instance_id` | The SQL Managed Instance ID |
| `mssql_managed_instance_dns_zone` | The DNS Zone where the SQL Managed Instance is located |
| `mssql_managed_instance_fqdn` | The fully qualified domain name of the Azure Managed SQL Instance |
| `mssql_managed_database_id` | The ID of the SQL Managed Database |
| `mssql_failover_group_id` | The ID of the Managed Instance Failover Group |
| `mssql_failover_group_partner_region` | The partner region block |
| `mssql_failover_group_role` | The local replication role of the Managed Instance Failover Group |
| `mssql_security_alert_policy_id` | The ID of the MS SQL Managed Instance Security Alert Policy |
| `mssql_start_stop_schedule_id` | The ID of the MS SQL Managed Instance Start Stop Schedule |
| `mssql_start_stop_schedule_next_execution_time` | Timestamp when the next action will be executed in the corresponding schedule time zone |
| `mssql_start_stop_schedule_next_run_action` | Next action to be executed (Start or Stop) |
| `mssql_vulnerability_assessment_id` | The ID of the Vulnerability Assessment |

<!-- END_TF_DOCS -->