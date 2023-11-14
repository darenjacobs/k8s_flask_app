#!/bin/sh

# check for terraform
is_terraform=$(which terraform)

if ! [[ "${is_terraform}" =~ "terraform" ]]; then
  echo "Terraform not found, Installing terraform"
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
fi

# Install gke-gcloud-auth-plugin
gcloud components install gke-gcloud-auth-plugin

# Run terraform
terraform init
terraform apply -auto-approve
