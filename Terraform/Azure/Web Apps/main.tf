# Created by pasaarni 19.5.2021 kesken

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "webapps-pa" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "wappsnet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.webapps.location
  resource_group_name = azurerm_resource_group.webapps.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "integrationsubnet" {
  name                 = var.network_subnet_name
  resource_group_name  = azurerm_resource_group.webapps.name
  virtual_network_name = azurerm_virtual_network.wappsnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "endpointsubnet" {
  name                 = var.endpoint_subnet_name
  resource_group_name  = azurerm_resource_group.webapps.name
  virtual_network_name = azurerm_virtual_network.wappsnet.name
  address_prefixes     = ["10.0.2.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = var.appservice_plan_name
  location            = azurerm_resource_group.webapps.location
  resource_group_name = azurerm_resource_group.webapps.name

  sku {
    tier = "Shared D1"
    size = "D1"
  }
}

resource "azurerm_app_service" "frontwebapp" {
  name                = var.front_webapp_name
  location            = azurerm_resource_group.webapps.location
  resource_group_name = azurerm_resource_group.webapps.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  app_settings = {
    "WEBSITE_DNS_SERVER": "1.1.1.1",
    "WEBSITE_VNET_ROUTE_ALL": "1"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id  = azurerm_app_service.frontwebapp.id
  subnet_id       = azurerm_subnet.integrationsubnet.id
}

resource "azurerm_app_service" "backwebapp" {
  name                = var.app_service_backweb_app_name
  location            = azurerm_resource_group.webapps.location
  resource_group_name = azurerm_resource_group.webapps.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
}

resource "azurerm_private_dns_zone" "dnsprivatezone" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.webapps.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
  name = "dnszonelink"
  resource_group_name = azurerm_resource_group.webapps.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone.name
  virtual_network_id = azurerm_virtual_network.wappsnet.id
}

resource "azurerm_private_endpoint" "wappsendpoint" {
  name                = var.private_dns_zone_vnet_name
  location            = azurerm_resource_group.webapps.location
  resource_group_name = azurerm_resource_group.webapps.name
  subnet_id           = azurerm_subnet.endpointsubnet.id

  private_dns_zone_group {
    name = var.private_dns_zone_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
  }

  private_service_connection {
    name = var.private_service_connection_name
    private_connection_resource_id = azurerm_app_service.backwebapp.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }
}
