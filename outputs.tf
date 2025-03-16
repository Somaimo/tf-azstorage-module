output "storage_accounts" {
  description = "Map of storage accounts created."
  value = {
    for k, v in azurerm_storage_account.this : k => {
      id                    = v.id
      name                  = v.name
      primary_access_key    = v.primary_access_key
      primary_blob_endpoint = v.primary_blob_endpoint
      primary_blob_host     = v.primary_blob_host
    }
  }
  sensitive = true
}

output "storage_containers" {
  description = "Map of storage containers created."
  value = {
    for k, v in azurerm_storage_container.this : k => {
      id   = v.id
      name = v.name
    }
  }
}

# output "private_endpoints" {
#   description = "Map of private endpoints created"
#   value = {
#     for k, v in azurerm_private_endpoint.this : k => {
#       id   = v.id
#       name = v.name
#       private_service_connection = v.private_service_connection
#     }
#   }
# }

# output "customer_managed_keys" {
#   description = "Map of customer managed keys used for storage accounts"
#   value = {
#     for k, v in azurerm_storage_account_customer_managed_key.this : k => {
#       id              = v.id
#       key_vault_key_id = v.key_vault_key_id
#     }
#   }
# }
