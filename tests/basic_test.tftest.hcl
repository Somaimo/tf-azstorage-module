variables {
  resource_group_name = "test-rg"
  location = "eastus"
  storage_accounts = {
    "sa1" = {
      name = "testaccount1634"
      account_tier = "Standard"
      account_replication_type = "LRS"
      tags = {
        environment = "test"
      }
    }
  }
}

run "create_basic_storage_account" {
  command = plan

  assert {
    condition = length(azurerm_storage_account.this) == 1
    error_message = "Should create exactly one storage account"
  }

  assert {
    condition = azurerm_storage_account.this["sa1"].name == "testaccount1634"
    error_message = "Storage account name doesn't match expected value"
  }

  assert {
    condition = azurerm_storage_account.this["sa1"].account_tier == "Standard"
    error_message = "Account tier doesn't match expected value"
  }

  assert {
    condition = azurerm_storage_account.this["sa1"].tags.environment == "test" 
    error_message = "Tags don't match expected values"
  }
}
