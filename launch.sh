#!/bin/sh

# Login to Azure
is_azcli=$(which az)

if ! [[ "${is_azcli}" =~ "az" ]]; then
  echo "Azure CLI not found, Installing Azure CLI"
  brew install azure-cli
fi
az login

# Push to Docker Hub
docker login
docker build -t darenjacobs/flask-app .
docker image tag flask-app darenjacobs/flask-app:latest
docker push darenjacobs/flask-app:latest


# check for Terraform
is_terraform=$(which terraform)

if ! [[ "${is_terraform}" =~ "terraform" ]]; then
  echo "Terraform not found, Installing terraform"
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
fi

# Run Terraform
terraform init
terraform plan -out sample.plan
terraform apply -auto-approve "sample.plan"
