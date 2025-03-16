# resource "azurerm_storage_account_customer_managed_key" "this" {
#   for_each = {
#     for k, v in var.storage_accounts : k => v.customer_managed_key if v.customer_managed_key != null
#   }

#   storage_account_id        = azurerm_storage_account.this[each.key].id
#   key_vault_key_id          = each.value.key_vault_key_id
#   user_assigned_identity_id = each.value.user_assigned_identity_id
  
#   depends_on = [azurerm_storage_account.this]
# }
