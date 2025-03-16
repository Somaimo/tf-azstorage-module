variables {
  resource_group_name = "test-rg"
  location = "eastus"
  storage_accounts = {
    "sa1" = {
      name = "testaccount1634"
      account_tier = "Standard"
      account_replication_type = "LRS"
      network_rules = {
        default_action = "Deny"
        bypass = ["AzureServices"]
        ip_rules = ["203.0.113.0/24"]
        virtual_network_subnet_ids = ["fake-subnet-id-for-testing"]
      }
    }
  }
}

run "create_storage_account_with_network_rules" {
  command = plan

  assert {
    condition = length(azurerm_storage_account.this) == 1
    error_message = "Should create exactly one storage account"
  }
  
  assert {
    condition = length(azurerm_storage_account_network_rules.this) == 1
    error_message = "Should create exactly one storage account network rule"
  }

  assert {
    condition = azurerm_storage_account_network_rules.this["sa1"].default_action == "Deny"
    error_message = "Network rules default action doesn't match expected value"
  }

  assert {
    condition = contains(azurerm_storage_account_network_rules.this["sa1"].bypass, "AzureServices")
    error_message = "Network rules bypass doesn't contain expected value"
  }

  assert {
    condition = contains(azurerm_storage_account_network_rules.this["sa1"].ip_rules, "203.0.113.0/24")
    error_message = "Network rules IP rules don't contain expected value"
  }
}
