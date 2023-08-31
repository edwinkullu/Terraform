terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "webterraformtfstate"
      container_name       = "terraformtfstate"
      key                  = "aksterraform.tfstate"
  }
  
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

