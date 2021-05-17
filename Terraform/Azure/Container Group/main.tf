# Create by pasaarni 17.5.2021

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cont-pa170521" {
  name     = "resurssi1"
  location = "North Europe"
}

resource "azurerm_container_group" "tprod1contnew" {
  name                = "kontti1"
  location            = azurerm_resource_group.cont-pa170521.location
  resource_group_name = azurerm_resource_group.cont-pa170521.name
  ip_address_type     = "public"
  dns_name_label      = "paci-label"
  os_type             = "Linux"

  container {
    name   = "hello-world3"
    image  = "microsoft/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "sidecar3"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing3"
  }
}

# Final line