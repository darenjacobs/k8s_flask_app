#!/bin/sh

az login
az aks delete --name my-cluster --resource-group my-resource-group
sleep 10
az group delete --name my-resource-group --yes

if [[ -f "./sample.plan" ]]; then
  rm sample.plan
fi

if [[ -f "./kubeconfig" ]]; then
  rm kubeconfig
fi
