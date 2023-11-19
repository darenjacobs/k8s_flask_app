#!/bin/sh

is_eksctl=$(which eksctl)

if [[ -z "${is_eksctl}" ]]; then
  echo "Installing eksctl"
fi

echo "Deleting Kubernetes service: 'my-app-service'"
kubectl delete svc my-app-service

echo "Deleting Kubernetes Cluster: 'my-cluster'"
eksctl delete cluster --name my-cluster --region us-east-1
