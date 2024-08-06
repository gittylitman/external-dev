provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "rgusersmanagement" {
  name     = var.resource_group_ext_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "sausersmanagement" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rgusersmanagement.name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "spusersmanagement" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.rgusersmanagement.name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_postgresql_flexible_server" "databaseusersmanagement" {
  name                   = var.server_name
  resource_group_name    = azurerm_resource_group.rgusersmanagement.name
  location               = azurerm_service_plan.spusersmanagement.location
  version                = var.server_version
  sku_name               = var.server_sku_name
  delegated_subnet_id    = "/subscriptions/22710479-535c-4bc6-9d25-2194bd78372f/resourceGroups/rg-int/providers/Microsoft.Network/virtualNetworks/vnet-int/subnets/snet-int"
  private_dns_zone_id = "/subscriptions/22710479-535c-4bc6-9d25-2194bd78372f/resourceGroups/rg-int/providers/Microsoft.Network/privateDnsZones/plink.postgres.database.azure.com"
  public_network_access_enabled = false
  administrator_login    = var.server_administrator_login
  administrator_password = var.server_administrator_password
  authentication {
    active_directory_auth_enabled = true
    tenant_id                     = var.tenant_id
  }

  lifecycle {
      ignore_changes = [
        zone,
        high_availability.0.standby_availability_zone
      ]
  }
}

resource "azurerm_linux_web_app" "wausersmanagement" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.rgusersmanagement.name
  location            = var.resource_group_location
  service_plan_id     = azurerm_service_plan.spusersmanagement.id
  
  depends_on = [ 
    azurerm_postgresql_flexible_server.databaseusersmanagement
  ]

  app_settings = {
    APP_ENV = "production"
    DB_CONNECTION = "pgsql"
    DB_DATABASE = "postgres"
    DB_HOST = "${azurerm_postgresql_flexible_server.databaseusersmanagement.name}.postgres.database.azure.com"
    DB_PASSWORD = var.server_administrator_password
    DB_USERNAME = var.server_administrator_login
    DB_PORT = 5432
    DEBUG = true
    WEBSITES_PORT = 8000
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = true
    WEBSITES_CONTAINER_START_TIME_LIMIT= 1700
    PORT = 8000
    MICROSOFT_GRAPH_TENANT_ID = ""
    MICROSOFT_GRAPH_CLIENT_SECRET = ""
    MICROSOFT_GRAPH_CLIENT_ID = ""
    GRAPH_URL = ""
    AZURE_TENANT_ID = ""
    AZURE_RESOURCE = ""
    AZURE_GROUP_ID_CLIENTS = ""
    AZURE_GROUP_ID_ADMINS = ""
    AZURE_CLIENT_SECRET = ""
    AZURE_CLIENT_ID = ""
    FUNCTION_APP= " "
    SUPER_ADMIN= " "
  }

  site_config {
    container_registry_use_managed_identity = true
    application_stack {
      docker_image_name = var.DOCKER_IMAGE
      docker_registry_url = var.DOCKER_REGISTARY_URL
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_linux_function_app" "linux_function_app" {
  name                        = var.function_app_name
  location                    = azurerm_storage_account.sausersmanagement.location
  resource_group_name         = azurerm_storage_account.sausersmanagement.resource_group_name
  service_plan_id             = azurerm_service_plan.spusersmanagement.id
  storage_account_name        = azurerm_storage_account.sausersmanagement.name
  storage_account_access_key  = azurerm_storage_account.sausersmanagement.primary_access_key
  functions_extension_version = "~4"

  app_settings = {
    AZURE_CLIENT_ID = " "
    AZURE_CLIENT_SECRET = " "
    AZURE_TENANT_ID = " "
    DEPARTMENT = " "
    EMAIL_SUFFIX = " "
    EMAIL_SUFFIX = " "
    GRAPH_URL = " "
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  site_config {
    always_on = true
    container_registry_use_managed_identity = true
    application_stack {
      docker {
        registry_url = var.DOCKER_REGISTARY_URL
        image_name = var.IMAGE_NAME
        image_tag = var.IMAGE_TAG
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_container_registry" "container_registry" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

resource "azurerm_role_assignment" "role_assignment_web_app" {
  principal_id                     = azurerm_linux_web_app.wausersmanagement.identity[0].principal_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "role_assignment_function_app" {
  principal_id                     = azurerm_linux_function_app.linux_function_app.identity[0].principal_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true
}