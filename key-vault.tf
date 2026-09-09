resource "azurerm_key_vault" "main" {
  name = "kvtf${substr(sha256(data.azurerm_client_config.current.subscription_id), 0, 8)}"

  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled    = true
  public_network_access_enabled = true
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false

  tags = {
    environment = "learning"
    project     = "azure-terraform-platform"
    managed_by  = "terraform"
  }
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.container_app.principal_id
}

resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}