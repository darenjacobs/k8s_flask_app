#!/bin/bash

# GET K8s service endpoint
endpoint=$(kubectl get service |grep my-app-service |awk '{ print $4 }')
URL="http://${endpoint}/"


# Create URL check
python3 -m pip install requests
echo "import requests" > check_endpoint.py
echo "response = requests.get(\"$URL\")" >> check_endpoint.py
echo "print(response)" >> check_endpoint.py
echo "print(response.status_code)" >> check_endpoint.py

# Additional Endpoint testing because Terraform "Checks" may timeout
python3 check_endpoint.py 2>&1 | tee check.txt
check=$(cat check.txt)
if [[ "${check}" =~ "200" ]]; then
  echo "ENDPOINT ${URL} TEST SUCCESSFUL"
else
  echo "***ERROR***: ENDPOINT ${URL} UNSUCCESSFUL"
fi

# Cleanup
rm check_endpoint.py
rm check.txt
