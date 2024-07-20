provider "google" {
  credentials = file("~/.config/gcloud/application_default_credentials.json")
  project     = "intense-vault-200013"
  region      = "us-central1"
}

resource "google_container_cluster" "my_cluster" {
  name                = "my-cluster"
  location            = "us-central1"
  enable_autopilot    = true
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
  config_path = "~/.kube/config"
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
  name       = "my-app"
  chart      = "${path.module}/flask-app"
  namespace  = "default"
  values     = [
    file("${path.module}/flask-app/values.yaml")
  ]
}

resource "null_resource" "health_check" {
  depends_on = [helm_release.flask_app]

  provisioner "local-exec" {
    command = <<EOT
      # Retrieve the external IP address of the service
      SERVICE_IP=$(kubectl get svc my-app-flask-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
      # Perform the health check
      STATUS_CODE=$(curl -s -o /dev/null -w "%%{http_code}" http://${SERVICE_IP})
      if [ "${STATUS_CODE}" -ne 200 ]; then
        echo "ERROR: returned an unhealthy status code: ${STATUS_CODE}"
        exit 1
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
