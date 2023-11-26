#!/bin/sh

# Set to your docker Username
DOCKER_USERNAME=darenjacobs

# check for terraform
is_terraform=$(which terraform)

if ! [[ "${is_terraform}" =~ "terraform" ]]; then
  echo "Terraform not found, Installing terraform"
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
fi

# Push to Docker Hub
docker login
docker build -t ${DOCKER_USERNAME}/flask-app .
docker image tag flask-app ${DOCKER_USERNAME}/flask-app:latest
docker push ${DOCKER_USERNAME}/flask-app:latest

# Run terraform
terraform init
terraform plan -out sample.plan
terraform apply -auto-approve "sample.plan"

# access the cluster
aws eks update-kubeconfig --region us-east-2 --name my-cluster

if [[ -f ./page_test.sh ]]; then
  bash ./page_test.sh
fi

sleep 120
terraform destroy -auto-approve

sleep 10
rm -rf terraform.tfstate*
rm -rf .terraform
rm sample.plan
