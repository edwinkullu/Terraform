terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
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
          "password" = "EHfLVC7BClMRAMinEQsuA7mFAMSdRtj7Pa2a4p3JMR+ACRDGHQwv"
          "email"    = "edwinkullu94@gmail.com"
          "auth"     = base64encode("azureregistery02:EHfLVC7BClMRAMinEQsuA7mFAMSdRtj7Pa2a4p3JMR+ACRDGHQwv")
        }
      }
    })
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
          image = "azureregistery02.azurecr.io/webapp:202306271059"
          name  = "webapp"
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
    }
}

}
}
}
	
