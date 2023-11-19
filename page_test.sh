#!/bin/bash

export KUBECONFIG="./kubeconfig"

endpoint=$(kubectl get service |grep my-app-service |awk '{ print $4 }')

pip3 install requests

echo "import requests" > check_endpoint.py
echo "response = requests.get(\"http://${endpoint}/\")" >> check_endpoint.py
echo "print(response)" >> check_endpoint.py
echo "print(response.status_code)" >> check_endpoint.py

python3 check_endpoint.py

rm check_endpoint.py
