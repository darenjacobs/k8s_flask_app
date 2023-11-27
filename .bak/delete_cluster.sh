#!/bin/sh

is_eksctl=$(which eksctl)

if [[ -z "${is_eksctl}" ]]; then
  echo "Installing eksctl"
fi

echo "Deleting Kubernetes service: 'my-app-service'"
kubectl delete svc my-app-service

echo "Deleting Kubernetes Cluster: 'my-cluster'"
eksctl delete cluster --name my-cluster --region us-east-2
aws kms delete-alias --region us-east-2  --alias-name alias/eks/my-cluster
aws logs delete-log-group --log-group-name /aws/eks/my-cluster/cluster --region us-east-2
