terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.26.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  # map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/cluster/my-cluster" = "shared"
    "kubernetes.io/role/elb"           = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-cluster" = "shared"
    "kubernetes.io/role/internal-elb"  = 1
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.20.0"
  cluster_name    = "my-cluster"
  cluster_version = "1.28"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name           = "node-group-1"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }

    two = {
      name           = "node-group-2"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }
}


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
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


check "response" {
  data "http" "my_app_service" {
    url = "http://${kubernetes_service.my_app_service.status.0.load_balancer.0.ingress.0.hostname}/"
  }

  assert {
    condition     = data.http.my_app_service.status_code == 200
    error_message = "ERROR: returned an unhealthy status code"
  }
}
