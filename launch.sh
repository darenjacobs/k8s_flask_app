#!/bin/sh

# Set to your docker Username
DOCKER_USERNAME=darenjacobs

# Login to Azure
is_azcli=$(which az)

if ! [[ "${is_azcli}" =~ "az" ]]; then
  echo "Azure CLI not found, Installing Azure CLI"
  brew install azure-cli
fi
az login

# Push to Docker Hub
docker login
docker build -t ${DOCKER_USERNAME}/flask-app .
docker image tag flask-app ${DOCKER_USERNAME}/flask-app:latest
docker push ${DOCKER_USERNAME}/flask-app:latest

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

if [[ -f ./page-test.sh ]]; then
  bash ./page-test.sh
fi

sleep 300
terraform destroy -auto-approve