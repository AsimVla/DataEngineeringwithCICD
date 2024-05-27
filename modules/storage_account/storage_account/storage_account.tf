//create storage account
resource "azurerm_storage_account" "storage" {
  name = var.storage_account_name
  resource_group_name = var.resource_group_name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "development"
  }
}

//create container in storage account with storage & destination folders
resource "azurerm_storage_container" "create_container" {
  for_each = {
    source = var.source_folder_name,
    destination = var.destination_folder_name
  }

  name = each.key
  storage_account_name = azurerm_storage_account.storage.name
  container_access_type = var.container_access_type
}

//create test file as storage blob
resource "azurerm_storage_blob" "create_test_file" {
  name                   = "test.txt"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.create_container["source"].name
  type                   = "Block"
  source_content = "Hello Asim!"
}

//output storage account key for further use
output "storage_account_key" {
  value = azurerm_storage_account.storage.primary_access_key
}