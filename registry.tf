data "azurerm_client_config" "current" {}

resource "azurerm_container_registry" "main" {
  name = "acrtf${substr(md5(data.azurerm_client_config.current.subscription_id), 0, 8)}"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"

  admin_enabled                 = false
  public_network_access_enabled = true

  tags = {
    environment = "learning"
    project     = "azure-terraform-platform"
    managed_by  = "terraform"
  }
}