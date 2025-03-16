module "azure_storage" {
  source = "../"

  resource_group_name = "az_storage_test"
  location            = "switzerlandnorth"

  storage_accounts = {
    "sa1" = {
      name                     = "polarsofaazstorageacc01"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      
      # Customer managed key configuration
      # customer_managed_key = {
      #   key_vault_key_id = "https://az-vault-storage-test.vault.azure.net/"
      #   user_assigned_identity_id = "keys/az-vault-test-enc-key/6e5df0e162cd4feea5360becce54734a"
      # }
      
      # Network rules configuration
    #   network_rules = {
    #     default_action = "Deny"
    #     ip_rules       = ["123.123.123.123"]
    #     bypass         = ["AzureServices"]
    #   }
      
      # Private endpoint configuration
    #   private_endpoints = {
    #     "pe1" = {
    #       name      = "storage-pe-blob"
    #       subnet_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/myvnet/subnets/mysubnet"
    #       private_dns_zone_ids = [
    #         "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    #       ]
    #       subresource_names = ["blob"]
    #     },
    #     "pe2" = {
    #       name      = "storage-pe-file"
    #       subnet_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/myvnet/subnets/mysubnet"
    #       private_dns_zone_ids = [
    #         "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    #       ]
    #       subresource_names = ["file"]
    #     }
    #   }
      
      # Container configuration
      containers = {
        "container1" = {
          name                  = "mycontainer1"
          container_access_type = "private"
        }
      }
    }
  }
}
