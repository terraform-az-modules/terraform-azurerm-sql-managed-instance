## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | Administrator login name for SQL authentication (required if Azure AD admin is not configured). | `string` | `"sqladmin"` | no |
| administrator\_login\_password | Administrator password for SQL authentication (required if Azure AD admin is not configured). | `string` | `null` | no |
| auto\_rotation\_enabled | When enabled, the SQL Managed Instance will continuously check the key vault for any new versions of the key being used as the TDE protector. If a new version of the key is detected, the TDE protector on the SQL Managed Instance will be automatically rotated to the latest key version within 60 minutes. | `bool` | `false` | no |
| azure\_active\_directory\_administrator | Azure Active Directory administrator configuration. | <pre>object({<br>    login_username                      = string<br>    object_id                           = string<br>    principal_type                      = string<br>    azuread_authentication_only_enabled = optional(bool, false)<br>    tenant_id                           = optional(string)<br>  })</pre> | `null` | no |
| collation | SQL collation for the Managed Instance. | `string` | `null` | no |
| custom\_name | Optional custom name to override the base name in tags. | `string` | `null` | no |
| database\_format | Database internal format. | `string` | `null` | no |
| deployment\_mode | Deployment mode identifier (e.g., blue/green, canary). | `string` | `"terraform"` | no |
| disabled\_alerts | List of disabled security alerts. | `list(string)` | `[]` | no |
| dns\_zone\_partner\_id | DNS zone partner managed instance ID. | `string` | `null` | no |
| email\_account\_admins\_enabled | Whether alerts are sent to account administrators. | `bool` | `false` | no |
| email\_addresses | Email addresses that receive security alerts. | `list(string)` | `[]` | no |
| enable\_diagnostic | Enable diagnostic settings for SQl Managed Instance. | `bool` | `true` | no |
| enable\_private\_endpoint | Enable private endpoint for the SQL Managed Instance. | `bool` | `true` | no |
| enable\_start\_stop\_schedule | Enable start/stop schedule for the SQL Managed Instance. | `bool` | `false` | no |
| enable\_transparent\_data\_encryption | Enable Transparent Data Encryption for the SQL Managed Instance. | `bool` | `false` | no |
| enabled | Enable or disable creation of all SQL Managed Instance resources. | `bool` | `true` | no |
| encryption | Enable customer-managed encryption for the SQL Managed Instance using Key Vault. | `bool` | `true` | no |
| endpoint\_subnet\_id | Subnet ID for Private Endpoint (must be non-delegated subnet) | `string` | n/a | yes |
| environment | Deployment environment (e.g., dev, stage, prod). | `string` | `null` | no |
| extra\_tags | Additional tags to apply to all resources. | `map(string)` | `{}` | no |
| failover\_enabled | Enable failover group for the SQL Managed Instance. | `bool` | `false` | no |
| hybrid\_secondary\_usage | Hybrid secondary usage mode. | `string` | `null` | no |
| identity | Managed identity configuration. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| key\_expiration\_date | Expiration date for the Key Vault key in ISO 8601 format (for example 2028-12-31T23:59:59Z). | `string` | `null` | no |
| key\_permissions | Key permissions to assign in Key Vault access policy or RBAC for this key. | `list(string)` | <pre>[<br>  "decrypt",<br>  "encrypt",<br>  "sign",<br>  "unwrapKey",<br>  "verify",<br>  "wrapKey"<br>]</pre> | no |
| key\_size | Size of the RSA key in bits (for example 2048, 3072, 4096). | `number` | `2048` | no |
| key\_type | Key type to create in Key Vault (for example RSA or RSA-HSM). | `string` | `"RSA-HSM"` | no |
| key\_vault\_id | ID of the Azure Key Vault used for customer-managed keys and secrets. | `string` | `null` | no |
| key\_vault\_rbac\_auth\_enabled | Enable role-based access control (RBAC) for authenticating to Key Vault instead of access policies. | `bool` | `true` | no |
| label\_order | Order of labels to be used in naming/tagging. | `list(string)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| license\_type | License type for the SQL Managed Instance. | `string` | `"LicenseIncluded"` | no |
| location | Azure region where resources will be deployed. | `string` | `null` | no |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID for diagnostics. | `string` | `null` | no |
| logs | List of log configurations for diagnostic settings. Each object can specify either category\_group or category. | <pre>list(object({<br>    category_group = optional(string)<br>    category       = optional(string)<br>  }))</pre> | `[]` | no |
| long\_term\_retention\_policy | Long-term backup retention policy for the SQL Managed Instance database. | <pre>object({<br>    monthly_retention = optional(string)<br>    week_of_year      = optional(number)<br>    weekly_retention  = optional(string)<br>    yearly_retention  = optional(string)<br>  })</pre> | `null` | no |
| maintenance\_configuration\_name | Maintenance configuration name. | `string` | `null` | no |
| managed\_hsm\_key\_id | To use customer managed keys from a managed HSM for transparent data encryption of SQL Managed Instance. | `string` | `null` | no |
| managedby | Tag to indicate the tool or team managing the resources. | `string` | `"terraform"` | no |
| manual\_connection | Indicates whether the connection is manual | `bool` | `false` | no |
| metric\_enabled | Boolean flag to specify whether Metrics should be enabled for the SQL Managed Instance. Defaults to true. | `bool` | `true` | no |
| minimum\_tls\_version | Minimum TLS version. | `string` | `"1.2"` | no |
| name | Base name for resources. | `string` | n/a | yes |
| partner\_managed\_instance\_id | The ID of the partner SQL Managed Instance used for failover groups. | `string` | `null` | no |
| point\_in\_time\_restore | Point-in-time restore configuration for the SQL Managed Instance database. | <pre>object({<br>    restore_point_in_time = string<br>    source_database_id    = string<br>  })</pre> | `null` | no |
| private\_dns\_zone\_ids | The ID of the private DNS zone associated with the SQL Managed Instance private endpoint. | `string` | `null` | no |
| proxy\_override | Proxy override mode. | `string` | `null` | no |
| public\_data\_endpoint\_enabled | Enable public data endpoint for the SQL Managed Instance. | `bool` | `false` | no |
| read\_write\_endpoint\_failover\_policy | Read-write endpoint failover policy configuration. | <pre>object({<br>    mode          = string<br>    grace_minutes = number<br>  })</pre> | `null` | no |
| readonly\_endpoint\_failover\_policy\_enabled | Specifies whether the read-only endpoint failover policy is enabled. | `bool` | `false` | no |
| repository | Repository URL or identifier for traceability. | `string` | `"https://github.com/terraform-az-modules/terraform-azurerm-sql-managed-instance.git"` | no |
| resource\_group\_name | Name of the resource group where resources will be deployed. | `string` | `null` | no |
| resource\_position\_prefix | If true, prefixes resource names instead of suffixing. | `bool` | `false` | no |
| retention\_days | Number of days to retain threat detection audit logs. | `number` | `0` | no |
| rotation\_policy\_config | Rotation policy configuration for keys stored in Key Vault (ISO 8601 duration format, for example P30D). | <pre>object({<br>    enabled              = bool<br>    time_before_expiry   = optional(string, null)<br>    expire_after         = optional(string, null)<br>    notify_before_expiry = optional(string, null)<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "expire_after": "P90D",<br>  "notify_before_expiry": "P29D",<br>  "time_before_expiry": "P30D"<br>}</pre> | no |
| secondary\_location | Azure region for secondary SQL Managed Instance (must be different from primary) | `string` | `null` | no |
| secondary\_resource\_group\_name | Resource group name for secondary instance (optional, defaults to primary RG) | `string` | `null` | no |
| secondary\_subnet\_id | Subnet ID for secondary SQL Managed Instance | `string` | `null` | no |
| security\_alert\_policy\_enabled | Specifies whether the security alert policy is enabled. | `bool` | `true` | no |
| service\_principal\_type | Service principal type. | `string` | `null` | no |
| short\_term\_retention\_days | Number of days to retain short-term backups for the SQL Managed Instance. | `number` | `7` | no |
| sku\_name | SKU name for the SQL Managed Instance. | `string` | `"GP_Gen5"` | no |
| start\_stop\_schedules | Start/stop schedule configuration for the SQL Managed Instance. | <pre>object({<br>    start_day  = string<br>    start_time = string # HH:MM<br>    stop_day   = string<br>    stop_time  = string # HH:MM<br>  })</pre> | `null` | no |
| start\_stop\_timezone\_id | Timezone ID used for the start/stop schedule. | `string` | `"UTC"` | no |
| storage\_account\_access\_key | Access key for the storage account used for audit logs. | `string` | `null` | no |
| storage\_account\_id | Storage account ID for diagnostic settings destination. | `string` | `null` | no |
| storage\_account\_type | Backup storage account type. | `string` | `"LRS"` | no |
| storage\_endpoint | Blob storage endpoint used to store threat detection audit logs. | `string` | `null` | no |
| storage\_size\_in\_gb | Maximum storage size in GB (must be a multiple of 32). | `number` | `32` | no |
| subnet\_id | Subnet ID where the SQL Managed Instance will be deployed. | `string` | `null` | no |
| timezone\_id | Timezone ID for the SQL Managed Instance. | `string` | `"UTC"` | no |
| va\_recurring\_scans | Recurring scans configuration for vulnerability assessment. | <pre>object({<br>    enabled                   = bool<br>    email_subscription_admins = bool<br>    emails                    = list(string)<br>  })</pre> | `null` | no |
| va\_storage\_account\_access\_key | Storage account access key used to write vulnerability assessment results. | `string` | `null` | no |
| va\_storage\_container\_path | Storage container path for vulnerability assessment (e.g., https://account.blob.core.windows.net/container/). | `string` | `null` | no |
| vcores | Number of vCores for the SQL Managed Instance. | `number` | `4` | no |
| vulnerability\_assessment\_enabled | Enable vulnerability assessment for the SQL Managed Instance. | `bool` | `false` | no |
| zone\_redundant\_enabled | Enable zone redundancy for the SQL Managed Instance. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| mssql\_failover\_group\_id | The ID of the Managed Instance Failover Group. |
| mssql\_failover\_group\_partner\_region | The partner region block. |
| mssql\_failover\_group\_role | The local replication role of the Managed Instance Failover Group. |
| mssql\_managed\_database\_id | The ID of the SQL Managed Database. |
| mssql\_managed\_instance\_dns\_zone | The DNS Zone where the SQL Managed Instance is located. |
| mssql\_managed\_instance\_fqdn | The fully qualified domain name of the Azure Managed SQL Instance. |
| mssql\_managed\_instance\_id | The SQL Managed Instance ID. |
| mssql\_security\_alert\_policy\_id | The ID of the MS SQL Managed Instance Security Alert Policy. |
| mssql\_start\_stop\_schedule\_id | The ID of the MS SQL Managed Instance Start Stop Schedule. |
| mssql\_start\_stop\_schedule\_next\_execution\_time | Timestamp when the next action will be executed in the corresponding schedule time zone. |
| mssql\_start\_stop\_schedule\_next\_run\_action | Next action to be executed (Start or Stop). |
| mssql\_transparent\_data\_encryption\_id | The ID of the MSSQL encryption protector. |
| mssql\_vulnerability\_assessment\_id | The ID of the Vulnerability Assessment. |

