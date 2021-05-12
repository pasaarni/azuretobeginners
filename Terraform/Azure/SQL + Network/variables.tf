variable "resource_group_name" {
    type        = string
    description = "Resource Group name in Azure"
}

variable "resource_group_location" {
    type        = string
    description = "Resource location name in Azure"
}

variable "app_service_plan_name" {
    type        = string
    description = "Resource App Service name in Azure"
}

variable "app_service_name" {
    type        = string
    description = "App Service name in Azure"
}

variable "sql_server_name" {
    type        = string
    description = "SQL Server name instance in Azure"
}

variable "sql_database_name" {
    type        = string
    description = "SQL Database name in Azure"
}

variable "sql_admin_login" {
    type        = string
    description = "SQL server login name in Azure"
}

variable "sql_admin_password" {
    type        = string
    description = "SQL Server password name in Azure"
}

variable "network_group_name" {
    type        = string
    description = "NG name in Azure"
}