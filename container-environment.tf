resource "azurerm_container_app_environment" "main" {
  name                = "cae-azure-terraform-dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  infrastructure_subnet_id       = azurerm_subnet.container_apps.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.main.id
  internal_load_balancer_enabled = false

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 0
  }

  tags = {
    environment = "learning"
    project     = "azure-terraform-platform"
    managed_by  = "terraform"
  }
}