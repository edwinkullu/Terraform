#This script is used for create Azure Kubernetes services cluster 

resource "azurerm_kubernetes_cluster" "WebappProject" {
  name                = "WebappProject-Aks1"
  location            = azurerm_resource_group.WebappProject.location
  resource_group_name = azurerm_resource_group.WebappProject.name
  dns_prefix          = "WebappProjectAks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Demoweb"
  }
}

