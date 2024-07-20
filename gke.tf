provider "google" {
  credentials = file("~/.config/gcloud/application_default_credentials.json")
  project     = "intense-vault-200013"
  region      = "us-central1"
}

resource "google_container_cluster" "my_cluster" {
  name                = "my-cluster"
  location            = "us-central1"

  enable_autopilot = true
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

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = []
      command     = "gke-gcloud-auth-plugin"
    }
  }
}

resource "helm_release" "flask_app" {
  name       = "flask-app"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "13.2.9"
  namespace  = "default"
  values     = [
    file("${path.module}/flask-app/values.yaml"),
    yamlencode({
      livenessProbe = {}
      readinessProbe = {}
      nginx = {
        livenessProbe = {}
        readinessProbe = {}
      }
    })
  ]
}

# Todo: fix this

# # Automated health check
# check "health_check" {
#   data "http" "my_app_service" {
#     url = "http://${helm_release.flask_app.status.load_balancer.ingress[0].ip}/"
#   }
#
#   assert {
#     condition     = data.http.my_app_service.status_code == 200
#     error_message = "ERROR: returned an unhealthy status code"
#   }
# }
