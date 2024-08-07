variable subscription_id {
  type = string
}

variable DOCKER_IMAGE {
  type = string
  default = "users-management:latest"
}

variable DOCKER_REGISTARY_URL {
  type = string
  default = "https://containerregistryautomationdev.azurecr.io"
}

variable resource_group_ext_name {
  type = string
  default = "rg-ext"
}

variable resource_group_location {
  type = string
  default = "West Europe"
}

variable storage_account_name {
  type    = string
  default = "sttryvnet"
}

variable service_plan_name {
  type = string
  default = "app-try-vnet"
}

variable tenant_id {
  type = string
  default = "c9ad96a7-2bac-49a7-abf6-8e932f60bf2b"
}

variable web_app_name {
  type = string
  default = "wa-try-vnet"
}

variable function_app_name {
  type    = string
  default = "func-vnet"
}

variable server_name {
  type = string
  default = "sqldb-try-vnet"
}

variable server_version {
  type = number
  default = 14
}

variable server_sku_name {
  type = string
  default = "GP_Standard_D2s_v3"
}

variable server_administrator_login {
  type = string
  default = "GDT"
}

variable server_administrator_password {
  type = string
  default = "GDT2024!"
}

variable acr_name {
  type = string
  default = "containerRegistryAutomationDev"
}

variable acr_resource_group_name {
  type = string
  default = "rg-dev"
}

variable IMAGE_NAME {
  type    = string
  default = "services/users_management/func_add_user"
}

variable IMAGE_TAG {
  type    = string
  default = "1.0.0"
}
