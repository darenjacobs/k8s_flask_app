#!/bin/bash

is_azcli=$(which az)

if [[ -z "${is_azcli}" ]]; then
  brew update && brew install azure-cli
fi

az aks list --query "[].{Name:name, Power:powerState.code}" -o table 2>&1 | tee output.txt

is_cluster_up=$(az aks list --query "[].{Name:name, Power:powerState.code}" -o table)
var=$(cat output.txt)
rm output.txt

if [[ "${var}" =~ "my-cluster" ]]; then
  echo "Accessing Cluster: 'my-cluster'"
  az aks get-credentials --resource-group my-resource-group --name my-cluster --file kubeconfig
else
  echo "Cluster 'my-cluster' Does not appear to be online"
fi

export KUBECONFIG="./kubeconfig"
