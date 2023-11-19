#!/bin/sh


# Install SDK
is_gcloud=$(which gcloud)
if ! [[ "${is_gcloud}" =~ "gcloud" ]]; then
  curl -o ~/Downloads/google-cloud-cli-455.0.0-darwin-x86_64.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-455.0.0-darwin-x86_64.tar.gz
  ~/Downloads/google-cloud-sdk/install.sh
  ~/Downloads/google-cloud-sdk/bin/gcloud init
fi

## # Install gke-gcloud-auth-plugin
## gcloud auth application-default login
## gcloud components install gke-gcloud-auth-plugin
## gcloud config set project ${GKE_PROJECT_ID}

# check for terraform
is_terraform=$(which terraform)

if ! [[ "${is_terraform}" =~ "terraform" ]]; then
  echo "Terraform not found, Installing terraform"
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
fi


# Run terraform
terraform init
terraform plan -out sample.plan
terraform apply -auto-approve "sample.plan"
