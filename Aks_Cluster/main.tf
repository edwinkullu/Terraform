
# Create a resource group
resource "azurerm_resource_group" "WebappProject" {
  name     = "WebappProject-resources"
  location = "centralindia"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "WebappProject" {
  name                = "WebappProject-network"
  resource_group_name = azurerm_resource_group.WebappProject.name
  location            = azurerm_resource_group.WebappProject.location
  address_space       = ["10.0.0.0/16"]
}

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

