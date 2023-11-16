#!/bin/bash

gcloud container clusters get-credentials my-cluster --region us-central1
endpoint=$(kubectl get svc | grep service |awk '{print $4}'); echo "Endpoint is http://${endpoint}/"
