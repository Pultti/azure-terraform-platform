resource "azurerm_container_app" "main" {
  name                         = "ca-azure-terraform-dev"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.container_app.id
    ]
  }

  secret {
    name                = "demo-api-key"
    identity            = azurerm_user_assigned_identity.container_app.id
    key_vault_secret_id = "${azurerm_key_vault.main.vault_uri}secrets/demo-api-key"
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.container_app.id
  }

  template {
    min_replicas = 0
    max_replicas = 1

    container {
      name   = "api"
      image  = "${azurerm_container_registry.main.login_server}/azure-platform-api:v1"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "PORT"
        value = "8080"
      }

      env {
        name        = "DEMO_API_KEY"
        secret_name = "demo-api-key"
      }
    }
  }

  ingress {
    external_enabled           = true
    allow_insecure_connections = false
    target_port                = 8080
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = {
    environment = "learning"
    project     = "azure-terraform-platform"
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_role_assignment.acr_pull,
    azurerm_role_assignment.key_vault_secrets_user
  ]
}