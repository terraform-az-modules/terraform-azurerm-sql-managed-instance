provider "azurerm" {
  features {}
}

module "sql-managed-instance" {
  source = "../../"
}
