#!/bin/sh

az aks delete --name my-cluster --resource-group my-resource-group
sleep 10
az group delete --name my-resource-group --yes