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
      key                  = "deploy_terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


data "azurerm_kubernetes_cluster" "WebappProject" {
  name                = "WebappProject-Aks1"
  resource_group_name = "WebappProject-resources"
}
provider "kubernetes" {

  # version = "<=2.0.1"

  host                   = data.azurerm_kubernetes_cluster.WebappProject.kube_config[0].host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.WebappProject.kube_config[0].client_certificate)

  client_key             = base64decode(data.azurerm_kubernetes_cluster.WebappProject.kube_config[0].client_key)

  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.WebappProject.kube_config[0].cluster_ca_certificate)

}

resource "kubernetes_namespace" "app_namespace" {

  metadata {

    name = "application"

  }

}

resource "kubernetes_secret" "WebappProject" {
  metadata {
    name = "docker-cfg"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "azureregistery02.azurecr.io" = {
          "username" = "azureregistery02"
          "password" = "pjNVEjJXVIcV4EdKKd0WaprI3zVt/KQDyq/ySy9phT+ACRCpMzW+"
          "email"    = "edwinkullu94@gmail.com"
          "auth"     = base64encode("azureregistery02:pjNVEjJXVIcV4EdKKd0WaprI3zVt/KQDyq/ySy9phT+ACRCpMzW+")
        }
      }
    })
  }
}
resource "kubernetes_config_map" "environmentvariable" {

  metadata {

    name      = "environmentvariable"

    namespace = kubernetes_namespace.app_namespace.metadata[0].name

  }

  data = {

    Environment      = "__Environment__"


  }

}


resource "kubernetes_deployment" "webapp" {
  metadata {
    name = "webapp"
    namespace = "application"
    labels = {
      app = "webapp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webapp"
      }
    }

    template {
      metadata {
        labels = {
            app = "webapp"
        }
      }

      spec {
        image_pull_secrets {

          name = kubernetes_secret.WebappProject.metadata[0].name

        }
        container {
          image = "azureregistery02.azurecr.io/webapp:202306280617"
          name  = "webapp"
          image_pull_policy = contains([__ProjectsToDeploy__], "webapp") == true ? "Always" : "IfNotPresent"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
        }
        env {

            name = "ENVIRONMENT"

            value_from {

              config_map_key_ref {

                key  = "Environment"

                name = kubernetes_config_map.environmentvariable.metadata[0].name

              }

            }

          }
    }
}

}
}
}
	
