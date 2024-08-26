variable subscription_id {
  type = string
  default = "22710479-535c-4bc6-9d25-2194bd78372f"
}

variable DOCKER_IMAGE {
  type = string
  default = "users-management:latest"
}

variable DOCKER_REGISTARY_URL {
  type = string
  default = "https://containerregistrydigprod.azurecr.io"
}

variable resource_group_ext_name {
  type = string
  default = "rg-users-management-prod"
}

variable resource_group_location {
  type = string
  default = "West Europe"
}

variable storage_account_name {
  type    = string
  default = "stusersmanagementprod"
}

variable service_plan_name {
  type = string
  default = "splan-users-management"
}

variable tenant_id {
  type = string
  default = "c9ad96a7-2bac-49a7-abf6-8e932f60bf2b"
}

variable web_app_name {
  type = string
  default = "wa-users-management-prod"
}

variable IMAGE_NAME_2 {
  type    = string
  default = "services/users_management/func_connect_planner"
}

variable function_app_name_planner {
  type    = string
  default = "func-connect-planner"
}
variable function_app_name {
  type    = string
  default = "func-add-user-prod"
}

variable server_name {
  type = string
  default = "sqldb-users-management-prod"
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
  default = "containerRegistryDIGProd"
}

variable acr_resource_group_name {
  type = string
  default = "rg-prod"
}


variable IMAGE_NAME {
  type    = string
  default = "services/users_management/func_add_user"
}

variable IMAGE_TAG {
  type    = string
  default = "1.0.0"
}