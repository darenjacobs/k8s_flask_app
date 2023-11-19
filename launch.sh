#!/bin/sh


# Install SDK
is_gcloud=$(which gcloud)
if ! [[ "${is_gcloud}" =~ "gcloud" ]]; then
  curl -o ~/Documents/google-cloud-cli-455.0.0-darwin-x86_64.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-455.0.0-darwin-x86_64.tar.gz
  ~/Documents/google-cloud-sdk/install.sh
  ~/Documents/google-cloud-sdk/bin/gcloud init
fi

## # Install gke-gcloud-auth-plugin
## gcloud auth application-default login
## gcloud components install gke-gcloud-auth-plugin
## gcloud config set project ${GKE_PROJECT_ID}


# Push to Docker
docker login
docker build -t darenjacobs/flask-app .
docker image tag flask-app darenjacobs/flask-app:latest
docker push darenjacobs/flask-app:latest


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
