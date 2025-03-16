variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage accounts."
  type        = string
}

variable "location" {
  description = "The Azure Region in which to create the storage accounts."
  type        = string
}

variable "storage_accounts" {
  description = "Map of storage accounts to create."
  type = map(object({
    name                     = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    account_kind             = optional(string, "StorageV2")
    access_tier              = optional(string, "Hot")
    min_tls_version          = optional(string, "TLS1_2")
    tags                     = optional(map(string), {})
    
    network_rules = optional(object({
      default_action             = optional(string, "Deny")
      bypass                     = optional(list(string), ["AzureServices"])
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), null)
    
    blob_properties = optional(object({
      versioning_enabled       = optional(bool, false)
      change_feed_enabled      = optional(bool, false)
      delete_retention_days    = optional(number, 7)
      container_delete_retention_days = optional(number, 7)
    }), null)
    
    customer_managed_key = optional(object({
      key_vault_key_id          = optional(string)
      user_assigned_identity_id = optional(string)
    }), null)
    
    private_endpoints = optional(map(object({
      name                          = optional(string)
      subnet_id                     = optional(string)
      private_dns_zone_ids          = optional(list(string), [])
      custom_dns_configs            = optional(list(object({
        fqdn                        = optional(string)
        ip_addresses                = optional(list(string))
      })), [])
      private_service_connection_name = optional(string)
      subresource_names             = optional(list(string), ["blob"])
      is_manual_connection          = optional(bool, false)
      tags                          = optional(map(string), {})
    })), {})
    
    containers = optional(map(object({
      name                  = string
      container_access_type = optional(string, "private")
      metadata              = optional(map(string), {})
    })), {})
  }))
  default = {}
}
