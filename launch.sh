#!/bin/sh

# check for terraform
is_terraform=$(which terraform)

if ! [[ "${is_terraform}" =~ "terraform" ]]; then
  echo "Terraform not found, Installing terraform"
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
fi

# Login to Azure
az login

# DELETE THIS
az account set --subscription 8eabaef9-7693-472b-8ee4-6ab9ebfd18ac

# Run terraform
terraform init
terraform plan
terraform apply -auto-approve
