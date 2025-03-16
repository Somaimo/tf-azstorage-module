resource "azurerm_storage_account_network_rules" "this" {
  for_each = {
    for k, v in var.storage_accounts : k => v.network_rules if v.network_rules != null
  }

  storage_account_id         = azurerm_storage_account.this[each.key].id
  default_action             = each.value.default_action
  bypass                     = each.value.bypass
  ip_rules                   = each.value.ip_rules
  virtual_network_subnet_ids = each.value.virtual_network_subnet_ids
}
