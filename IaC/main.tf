resource "azurerm_resource_group" "default" {
  name     = "default"
  location = "West US"
}
resource "azurerm_storage_account" "default" {
  name                     = "bpf7701sa"
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}
resource "azurerm_storage_container" "default" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "blob" # was "private"
}

resource "azurerm_storage_blob" "sample_csv" {
  name                   = "file.csv"
  storage_account_name   = azurerm_storage_account.default.name
  storage_container_name = azurerm_storage_container.default.name
  type                   = "Block"
  source                 = "../file.csv"
}


resource "azurerm_storage_blob" "sample_pdf" {
  name                   = "file.pdf"
  storage_account_name   = azurerm_storage_account.default.name
  storage_container_name = azurerm_storage_container.default.name
  type                   = "Block"
  source                 = "../file.pdf"
}



# resource "azurerm_role_assignment" "example" {
#   scope              = azurerm_storage_account.example.id
#   role_definition_id = data.azurerm_role_definition.storage_blob_data_reader.id
#   principal_id       = "public"
# }

# data "azurerm_role_definition" "storage_blob_data_reader" {
#   name = "Storage Blob Data Reader"
# }



/*
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
data "azurerm_key_vault_secret" "MyFirstSecret" {
  name         = "MyFirstSecret"
  key_vault_id = azurerm_key_vault.default.id
  depends_on = [azurerm_key_vault.default, azurerm_key_vault_secret.MyFirstSecret]
}
output "MyFirstSecret" {
  value = "${data.azurerm_key_vault_secret.MyFirstSecret.value}"
  sensitive = true
}
resource "azurerm_sql_server" "mysqlserver" {
  name                         = "bpfsqlserver"
  resource_group_name          = azurerm_resource_group.default.name
  location                     = azurerm_resource_group.default.location
  version                      = "12.0"
  administrator_login          = "bpf"
  administrator_login_password = data.azurerm_key_vault_secret.MyFirstSecret.value
  #"${random_string.MyFirstSecret.result}"
}
resource "azurerm_sql_database" "terraform-demo-sql-database" {
  name                = "terraform-demo-sql-database"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  server_name         = azurerm_sql_server.mysqlserver.name
}

resource "azurerm_data_factory" "ADF01" {
  name                = "bpf7701ADF01"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}
resource "azurerm_data_factory_pipeline" "ADF01PL01" {
  name            = "ADF01PL01"
  #data_factory_id = azurerm_data_factory.ADF01.id
  data_factory_name = azurerm_data_factory.ADF01.name
  resource_group_name = azurerm_resource_group.default.name
}
*/