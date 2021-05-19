variable resource_group_name {
  type        = string
  description = "Name of the Vapps Resource Group"
}

variable resource_group_location {
  type        = string
  description = "Default location for Resource Group"
}

variable virtual_network_name {
    type = string
    description = "Wapps Virtual Network Name"
}

variable network_subnet_name {
    type = string
    description = "Subnet name of network subnet"
}

variable endpoint_subnet_name {
    type = string
    description = "Endpoint subnet name"
}

variable appservice_plan_name {
    type = string
    description = "AppService Plan Name"
}

variable front_webapp_name {
    type = string
    description = "Front WebApp Name"
}

variable app_service_backweb_app_name {
    type = string
    description = "BackWebApp Service Name"
}

variable private_dns_zone_name {
    type = string
    description = "Private DNS Zone name"
}

variable private_dns_zone_vnet_link {
    type = string
    description = "Private DNS Zone Vnet Link name"
}

variable private_dns_zone_group_name {
    type = string
    description = "Private DNS group name"
}

variable private_service_connection_name {
    type = string
    description = "Private Service Connection name"
}

variable private_dns_zone_vnet_name {
    type = string
    description = "Private DNS Zone Vnet Name"
}
