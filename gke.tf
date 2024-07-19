provider "google" {
  credentials = file("~/.config/gcloud/application_default_credentials.json")
  project     = "intense-vault-200013"
  region      = "us-central1"
}

resource "google_container_cluster" "my_cluster" {
  name                = "my-cluster"
  location            = "us-central1"
  # deletion_protection = false # Set deletion protection to false

  # Enabling Autopilot for this cluster
  enable_autopilot = true

  initial_node_count = 1

  # node_config {
  #   machine_type = "n1-standard-1"
  # }
}

data "google_client_config" "provider" {}
data "google_container_cluster" "my_cluster" {
  name       = "my-cluster"
  location   = "us-central1"
  depends_on = [google_container_cluster.my_cluster]
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = []
    command     = "gke-gcloud-auth-plugin"
  }
}

# resource "kubernetes_deployment" "my_app" {
#   metadata {
#     name = "my-app"
#   }
#
#   spec {
#     replicas = 1
#
#     selector {
#       match_labels = {
#         app = "my-app"
#       }
#     }
#
#     template {
#       metadata {
#         labels = {
#           app = "my-app"
#         }
#       }
#
#       spec {
#         container {
#           name  = "my-app"
#           image = "darenjacobs/flask-app:latest"
#           port {
#             container_port = 8080
#           }
#         }
#       }
#     }
#   }
# }

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




# some form of automated tests to validate the environment.
# New feature in Terraform:https://github.com/hashicorp/terraform/releases/tag/v1.5.0  https://developer.hashicorp.com/terraform/language/checks

check "health_check" {
  data "http" "my_app_service" {
    url = "http://${kubernetes_service.my_app_service.status.0.load_balancer.0.ingress.0.ip}/"
  }

  assert {
    condition     = data.http.my_app_service.status_code == 200
    error_message = "ERROR: returned an unhealthy status code"
  }
}
