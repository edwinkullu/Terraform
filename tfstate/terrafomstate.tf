terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}



resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "centralindia"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "webterraformtfstate"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  
  tags = {
    environment = "Demoweb"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "terraformtfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

