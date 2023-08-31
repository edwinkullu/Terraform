output "client_certificate" {
  value     = azurerm_kubernetes_cluster.WebappProject.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.WebappProject.kube_config_raw

  sensitive = true
}

output "login_server" {
  value = data.azurerm_container_registry.WebappProject.login_server
}
