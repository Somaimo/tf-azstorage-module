variables {
  resource_group_name = "test-rg"
  location = "eastus"
  storage_accounts = {
    "sa1" = {
      name = "testaccount1634"
      account_tier = "Standard"
      account_replication_type = "LRS"
      private_endpoints = {
        "pe1" = {
          name = "storage-pe-blob"
          subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
          private_dns_zone_ids = [
            "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
          ]
          subresource_names = ["blob"]
          tags = {
            purpose = "testing"
          }
        },
        "pe2" = {
          name = "storage-pe-file"
          subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
          subresource_names = ["file"]
        }
      }
    }
  }
}

run "create_storage_account_with_private_endpoints" {
  command = plan

  assert {
    condition = length(azurerm_storage_account.this) == 1
    error_message = "Should create exactly one storage account"
  }
  
  assert {
    condition = length(azurerm_private_endpoint.this) == 2
    error_message = "Should create exactly two private endpoints"
  }

  assert {
    condition = contains(keys(azurerm_private_endpoint.this), "sa1.pe1")
    error_message = "Private endpoint sa1.pe1 should exist"
  }

  assert {
    condition = azurerm_private_endpoint.this["sa1.pe1"].name == "storage-pe-blob"
    error_message = "Private endpoint name doesn't match expected value"
  }

  assert {
    condition = azurerm_private_endpoint.this["sa1.pe1"].private_service_connection[0].subresource_names[0] == "blob"
    error_message = "Private endpoint subresource name doesn't match expected value"
  }

  assert {
    condition = azurerm_private_endpoint.this["sa1.pe1"].tags.purpose == "testing"
    error_message = "Private endpoint tags don't match expected value"
  }

  assert {
    condition = length(azurerm_private_endpoint.this["sa1.pe1"].private_dns_zone_group) == 1
    error_message = "Private endpoint DNS zone group should exist"
  }

  assert {
    condition = azurerm_private_endpoint.this["sa1.pe2"].private_service_connection[0].subresource_names[0] == "file"
    error_message = "Second private endpoint subresource name doesn't match expected value"
  }
}
