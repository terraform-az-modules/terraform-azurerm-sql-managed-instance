provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current_client_config" {}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azurerm"
  version     = "1.0.3"
  name        = "core"
  environment = "dev"
  location    = "centralus"
  label_order = ["name", "environment", "location"]
}

# ------------------------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------------------------
module "vnet" {
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.3"
  name                = "core"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

# ------------------------------------------------------------------------------
# Subnet
# ------------------------------------------------------------------------------
module "subnet" {
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.1"
  environment          = "dev"
  label_order          = ["name", "environment", "location"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  enable_route_table   = true
  subnets = [
    {
      name              = "subnet1"
      subnet_prefixes   = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    },
    {
      name             = "sqlmi-subnet"
      subnet_prefixes  = ["10.0.3.0/27"]
      route_table_name = "sql-table"
      delegations = [
        {
          name = "sqlmi-delegation"
          service_delegations = [
            {
              name = "Microsoft.Sql/managedInstances"
              actions = [
                "Microsoft.Network/virtualNetworks/subnets/join/action",
                "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
                "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
              ]
            }
          ]
        }
      ]
    }
  ]
  route_tables = [
    {
      name                          = "sql-table"
      bgp_route_propagation_enabled = true
      routes                        = []
    }
  ]
}

module "security_group" {
  source              = "terraform-az-modules/nsg/azurerm"
  version             = "1.0.2"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_ids          = [module.subnet.subnet_ids.sqlmi-subnet]
  inbound_rules       = []
}

# ------------------------------------------------------------------------------
# Log Analytics
# ------------------------------------------------------------------------------
module "log-analytics" {
  source                      = "terraform-az-modules/log-analytics/azurerm"
  version                     = "1.0.2"
  name                        = "core"
  environment                 = "dev"
  label_order                 = ["name", "environment", "location"]
  log_analytics_workspace_sku = "PerGB2018"
  resource_group_name         = module.resource_group.resource_group_name
  location                    = module.resource_group.resource_group_location
  log_analytics_workspace_id  = module.log-analytics.workspace_id
}

# ------------------------------------------------------------------------------
# Key Vault
# ------------------------------------------------------------------------------
module "vault" {
  source                        = "terraform-az-modules/key-vault/azurerm"
  version                       = "1.0.1"
  name                          = "core"
  environment                   = "dev"
  label_order                   = ["name", "environment", "location"]
  resource_group_name           = module.resource_group.resource_group_name
  location                      = module.resource_group.resource_group_location
  subnet_id                     = module.subnet.subnet_ids.subnet1
  public_network_access_enabled = true
  custom_name                   = "zimbano3od"
  sku_name                      = "premium"
  private_dns_zone_ids          = module.private_dns_zone.private_dns_zone_ids.key_vault
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["0.0.0.0/0"]
  }
  reader_objects_ids = {
    "Key Vault Administrator" = {
      role_definition_name = "Key Vault Administrator"
      principal_id         = data.azurerm_client_config.current_client_config.object_id
    }
  }
  diagnostic_setting_enable  = true
  log_analytics_workspace_id = module.log-analytics.workspace_id
}

# ------------------------------------------------------------------------------
# Private DNS Zone
# ------------------------------------------------------------------------------
module "private_dns_zone" {
  source              = "terraform-az-modules/private-dns/azurerm"
  version             = "1.0.2"
  name                = "core"
  environment         = "dev"
  resource_group_name = module.resource_group.resource_group_name
  label_order         = ["name", "environment", "location"]
  private_dns_config = [
    {
      resource_type = "sql_server"
      vnet_ids      = [module.vnet.vnet_id]
    },
    {
      resource_type = "key_vault"
      vnet_ids      = [module.vnet.vnet_id]
    }
  ]
}

##-----------------------------------------------------------------------------
## MSSQL Managed Instance module
##-----------------------------------------------------------------------------
module "sql_instance" {
  source                     = "../../"
  name                       = "core"
  environment                = "dev"
  resource_group_name        = module.resource_group.resource_group_name
  label_order                = ["name", "environment", "location"]
  location                   = module.resource_group.resource_group_location
  subnet_id                  = module.subnet.subnet_ids.sqlmi-subnet
  key_vault_id               = module.vault.id
  endpoint_subnet_id         = module.subnet.subnet_ids.subnet1
  private_dns_zone_ids       = module.private_dns_zone.private_dns_zone_ids.sql_server
  log_analytics_workspace_id = module.log-analytics.workspace_id
}