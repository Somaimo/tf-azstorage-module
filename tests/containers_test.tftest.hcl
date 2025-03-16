variables {
  resource_group_name = "test-rg"
  location = "eastus"
  storage_accounts = {
    "sa1" = {
      name = "testaccount1634"
      account_tier = "Standard"
      account_replication_type = "LRS"
      containers = {
        "container1" = {
          name = "test-container-1"
          container_access_type = "private"
        },
        "container2" = {
          name = "test-container-2"
          container_access_type = "blob"
          metadata = {
            purpose = "testing"
          }
        }
      }
    }
  }
}

run "create_storage_account_with_containers" {
  command = plan

  assert {
    condition = length(azurerm_storage_account.this) == 1
    error_message = "Should create exactly one storage account"
  }
  
  assert {
    condition = length(azurerm_storage_container.this) == 2
    error_message = "Should create exactly two storage containers"
  }

  assert {
    condition = contains(keys(azurerm_storage_container.this), "sa1.container1")
    error_message = "Container sa1.container1 should exist"
  }

  assert {
    condition = azurerm_storage_container.this["sa1.container2"].container_access_type == "blob"
    error_message = "Container access type doesn't match expected value"
  }

  assert {
    condition = azurerm_storage_container.this["sa1.container2"].metadata.purpose == "testing"
    error_message = "Container metadata doesn't match expected value"
  }
}
