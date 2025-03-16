resource "azurerm_storage_account" "this" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  account_kind             = each.value.account_kind
  access_tier              = each.value.access_tier
  min_tls_version          = each.value.min_tls_version
  tags                     = each.value.tags

  dynamic "blob_properties" {
    for_each = each.value.blob_properties != null ? [each.value.blob_properties] : []
    
    content {
      versioning_enabled       = blob_properties.value.versioning_enabled
      change_feed_enabled      = blob_properties.value.change_feed_enabled
      
      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_days > 0 ? [blob_properties.value.delete_retention_days] : []
        
        content {
          days = delete_retention_policy.value
        }
      }
      
      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_days > 0 ? [blob_properties.value.container_delete_retention_days] : []
        
        content {
          days = container_delete_retention_policy.value
        }
      }
    }
  }
  
  dynamic "identity" {
    for_each = each.value.customer_managed_key != null ? [1] : []
    
    content {
      type = each.value.customer_managed_key.user_assigned_identity_id != null ? "UserAssigned" : "SystemAssigned"
      identity_ids = each.value.customer_managed_key.user_assigned_identity_id != null ? [each.value.customer_managed_key.user_assigned_identity_id] : null
    }
  }
}
