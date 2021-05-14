# Created by pasaarni

# Define Provider
provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "vnetsql01-test" {
  name     = var.resource_group_name
  location = var.resource_group_location
 
  tags = {
    environment = "test-env"
  }
}


# Create virtual network to resource group
resource "azurerm_virtual_network" "network" {
  name                = var.network_group_name
  resource_group_name = azurerm_resource_group.vnetsql01-test.name
  location            = azurerm_resource_group.vnetsql01-test.location
  address_space       = ["10.0.0.0/16"]
}

# Create subnet to virtual network
resource "azurerm_subnet" "subnet" {
  name                 = "vnet-subnet"
  resource_group_name  = azurerm_resource_group.vnetsql01-test.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.5.0/16"]
  service_endpoints    = ["Microsoft.Sql"]
}

# Create SQL server to resource group
resource "azurerm_sql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.vnetsql01-test.name
  location                     = azurerm_resource_group.vnetsql01-test.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

# Create Storage account
resource "azurerm_storage_account" "storageaccount" {
  name                     = "staccount"
  resource_group_name      = azurerm_resource_group.vnetsql01-test.name
  location                 = azurerm_resource_group.vnetsql01-test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create SQL-database
resource "azurerm_sql_database" "vnetsql01-test" {
  name                = var.sql_database_name
  resource_group_name = azurerm_resource_group.vnetsql01-test.name
  location            = azurerm_resource_group.vnetsql01-test.location
  server_name         = azurerm_sql_server.sqlserver.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storageaccount.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storageaccount.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
}
