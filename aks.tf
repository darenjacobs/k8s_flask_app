terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.81.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "my_resource_group" {
  name     = "my-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "my_cluster" {
  name                = "my-cluster"
  kubernetes_version  = 1.28
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kube_config" {
  depends_on = [azurerm_kubernetes_cluster.my_cluster]
  filename   = "kubeconfig"
  content    = azurerm_kubernetes_cluster.my_cluster.kube_config_raw
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.my_cluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.my_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.my_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.my_cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_deployment" "my_app" {
  metadata {
    name = "my-app"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = "darenjacobs/flask-app:latest"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my_app_service" {
  metadata {
    name = "my-app-service"
  }

  spec {
    selector = {
      app = "my-app"
    }

    type = "LoadBalancer"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8080
    }
  }
}

# Automated tests to validate the environment.
check "health_check" {
  data "http" "my_app_service" {
    url = "http://${kubernetes_service.my_app_service.status.0.load_balancer.0.ingress.0.ip}/"
  }

  assert {
    condition     = data.http.my_app_service.status_code == 200
    error_message = "ERROR: returned an unhealthy status code"
  }
}
