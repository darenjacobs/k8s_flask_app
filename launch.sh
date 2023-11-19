#!/bin/sh

# check for terraform
is_terraform=$(which terraform)

if ! [[ "${is_terraform}" =~ "terraform" ]]; then
  echo "Terraform not found, Installing terraform"
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
fi

# Push to Docker Hub
docker login
docker build -t darenjacobs/flask-app .
docker image tag flask-app darenjacobs/flask-app:latest
docker push darenjacobs/flask-app:latest

# Run terraform
terraform init
terraform plan -out sample.plan
terraform apply -auto-approve "sample.plan"
