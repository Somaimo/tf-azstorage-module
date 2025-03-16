# locals {
#   # Flatten storage account private endpoints
#   private_endpoints = flatten([
#     for sa_key, sa in var.storage_accounts : [
#       for pe_key, pe in sa.private_endpoints : {
#         sa_key                      = sa_key
#         pe_key                      = pe_key
#         name                        = pe.name
#         subnet_id                   = pe.subnet_id
#         private_dns_zone_ids        = pe.private_dns_zone_ids
#         custom_dns_configs          = pe.custom_dns_configs
#         private_service_connection_name = coalesce(pe.private_service_connection_name, "${pe.name}-connection")
#         subresource_names           = pe.subresource_names
#         is_manual_connection        = pe.is_manual_connection
#         tags                        = pe.tags
#       }
#     ]
#   ])
# }

# resource "azurerm_private_endpoint" "this" {
#   for_each = {
#     for pe in local.private_endpoints : 
#     "${pe.sa_key}.${pe.pe_key}" => pe
#   }

#   name                = each.value.name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = each.value.subnet_id
#   tags                = each.value.tags

#   private_service_connection {
#     name                           = each.value.private_service_connection_name
#     private_connection_resource_id = azurerm_storage_account.this[each.value.sa_key].id
#     is_manual_connection           = each.value.is_manual_connection
#     subresource_names              = each.value.subresource_names
#   }

#   dynamic "private_dns_zone_group" {
#     for_each = length(each.value.private_dns_zone_ids) > 0 ? [1] : []
    
#     content {
#       name                 = "default"
#       private_dns_zone_ids = each.value.private_dns_zone_ids
#     }
#   }

#   dynamic "custom_dns_configs" {
#     for_each = each.value.custom_dns_configs
    
#     content {
#       fqdn          = custom_dns_configs.value.fqdn
#       ip_addresses  = custom_dns_configs.value.ip_addresses
#     }
#   }
# }
