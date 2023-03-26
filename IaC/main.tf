resource "azurerm_resource_group" "default" {
  name     = "default"
  location = "West US"
}
resource "azurerm_storage_account" "default" {
  name                     = "bpf7701sa"
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}
resource "azurerm_key_vault" "default" {
  name                     = "bpf7701kv"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard" #"premium"
  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}
resource "random_string" "MyFirstSecret" {
  length  = 16
  upper   = true
  special = false
  numeric  = true 
}
resource "azurerm_key_vault_secret" "MyFirstSecret" {
  name         = "MyFirstSecret"
  value        = "${random_string.MyFirstSecret.result}"
  key_vault_id = azurerm_key_vault.default.id
}

# resource "azurerm_data_factory" "ADF01" {
#   name                = "ADF01"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
# }
# resource "azurerm_data_factory_pipeline" "ADF01PL01" {
#   name            = "ADF01PL01"
#   #data_factory_id = azurerm_data_factory.ADF01.id
#   data_factory_name = azurerm_data_factory.ADF01.name
#   resource_group_name = azurerm_resource_group.default.name
# }
