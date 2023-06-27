/*resource "azurerm_container_registry" "WebappProject" {
  name                = "containerRegistry025"
  resource_group_name = azurerm_resource_group.WebappProject.name
  location            = azurerm_resource_group.WebappProject.location
  sku                 = "Standard"
}


resource "azurerm_role_assignment" "WebappProject" {
  principal_id                     = azurerm_kubernetes_cluster.WebappProject.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.WebappProject.id
  skip_service_principal_aad_check = true
}
*/