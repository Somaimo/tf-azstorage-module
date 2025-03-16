locals {
  # Flatten storage containers for easier iteration
  storage_containers = flatten([
    for sa_key, sa in var.storage_accounts : [
      for c_key, container in sa.containers : {
        sa_key           = sa_key
        container_key    = c_key
        name             = container.name
        access_type      = container.container_access_type
        metadata         = container.metadata
      }
    ]
  ])
}

resource "azurerm_storage_container" "this" {
  for_each = {
    for container in local.storage_containers :
    "${container.sa_key}.${container.container_key}" => container
  }

  name                  = each.value.name
  storage_account_id  = azurerm_storage_account.this[each.value.sa_key].id
  container_access_type = each.value.access_type
  metadata              = each.value.metadata
}
