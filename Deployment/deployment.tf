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


data "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  resource_group_name = "example-resources"
}
provider "kubernetes" {

  # version = "<=2.0.1"

  host                   = data.azurerm_kubernetes_cluster.example.kube_config[0].host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].client_certificate)

  client_key             = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].client_key)

  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].cluster_ca_certificate)

}
resource "kubernetes_secret" "example" {
  metadata {
    name = "docker-cfg"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "containerregistry025.azurecr.io" = {
          "username" = "containerRegistry025"
          "password" = "4ItuVNCDq6my3NUBRY+mdRyogrROsf203yKmRiI44n+ACRDXWYUG"
          "email"    = "edwinkullu94@gmail.com"
          "auth"     = base64encode("containerRegistry025:4ItuVNCDq6my3NUBRY+mdRyogrROsf203yKmRiI44n+ACRDXWYUG")
        }
      }
    })
  }
}


resource "kubernetes_namespace" "app_namespace" {

  metadata {

    name = "personal"

  }

}
resource "kubernetes_deployment" "webapp" {
  metadata {
    name = "webapp"
    namespace = "personal"
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

          name = kubernetes_secret.example.metadata[0].name

        }
        container {
          image = "containerregistry025.azurecr.io/webapp:20230612_124513"
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
	
