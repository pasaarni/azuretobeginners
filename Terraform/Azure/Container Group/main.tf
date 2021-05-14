# Create by pasaarni 14.5.2021

resource "azurerm_resource_group" "cont-pa140521" {
  name     = "esmeporukka1"
  location = "North Europe"
}

resource "azurerm_container_group" "tprod1contnew" {
  name                = "esmekontti1"
  location            = azurerm_resource_group.cont-pa140521.location
  resource_group_name = azurerm_resource_group.cont-pa140521.name
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "microsoft/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "sidecar"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
}