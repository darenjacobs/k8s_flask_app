#!/bin/sh

# gcloud auth application-default login
gcloud container clusters get-credentials my-cluster --region us-central1
gcloud container clusters delete my-cluster --region us-central1
