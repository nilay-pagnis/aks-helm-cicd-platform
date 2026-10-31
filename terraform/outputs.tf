output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "github_client_id" {
  value = azuread_application.github.client_id
}

output "tenant_id" {
  value = azuread_service_principal.github.application_tenant_id
}
