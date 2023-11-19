#!/bin/sh

# Get subscription ID from
# az account list -o table |grep "AzureCloud" | awk '{ print $4}'

# Create Service Principal account
az ad sp create-for-rbac \
  --name github-actions-sp \
  --scope /subscriptions/$SUBSCRIPTION \
  --role Contributor \
  --sdk-auth
