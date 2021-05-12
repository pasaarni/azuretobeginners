# Maaritellaan PASI
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}

# Maaritellaan resurssiryhma
resource "azurerm_resource_group" "testiryhma21" {
  name     = var.resource_group_name
  location = var.resource_group_location
}