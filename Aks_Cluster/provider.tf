terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  /*backend "azurerm" {
    resource_group_name = "AcrRegistryGroup"
    storage_account_name = "webappprojecttfstate"
    container_name = "terraformtfstate"
    key = "terraform.tfstate"    
    }
    */
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

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