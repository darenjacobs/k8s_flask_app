# Kubernetes Flask App


# USER GUIDE

Clone this Repository:
```console
git clone https://github.com/darenjacobs/k8s_flask_app.git
```

TLDR:
The easiest way to deploy the Flask App is to [SET GITHUB ACTIONS SECRETS](#set-secrets) and commit to the branch.



### ABOUT THE FLASK APP
```
Written in Python, the flask application, app.py listens on port 8080 and displays the JSON text:
{
“message”: “Automate all the things!”,
“timestamp”: 1529729125
}
```

### RUN THE FLASK APP LOCALLY
```console
pip3 install flask
python3 app/app.py
```
visit http://127.0.0.1:8080/ in your web browser


### SINGLE COMMAND TO LAUNCH THE ENVIRONMENT AND DEPLOY THE APPLICATON
```console
bash launch.sh
```
Running the script launch.sh performs the AZURE LOGIN, PREREQUISITES and CLOUD DEPLOYMENT.


#### AZURE LOGIN
```console
az login
```

### PREREQUISITES
```console
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### CLOUD DEPLOYMENT

```console
terraform init
terraform plan
terraform apply
```

### AUTOMATED TESTING
```
After deployment Terraform will automatically check the status of the service to validate that it returns a 200 response

The ultimate result from Terraform yields the public IP. Execute a curl command using that IP.
data.http.my_app_service: Reading...
data.http.my_app_service: Read complete after 0s [id=http://PUBLIC_IP/]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
$ curl http://PUBLIC_IP/
{
  "message": "Automate all the things!",
  "timestamp": 1699943619
}
```

### DELETE THE APP & CLUSTER
```console
terraform destroy -auto-approve
```


## CI / CD PIPELINE
Any commits to the branch will start the pipeline which will test the app, deploy the app to Docker Hub, create a K8s cluster in the respective Cloud provider, and deploy the app to the cluster.


### SET SECRETS
- AZURE_CREDENTIALS - Service Principal credentials with contributor access to your subscription
- DOCKER_NAME - flask-app
- DOCKER_USERNAME - your dockerhub username
- DOCKER_PASSWORD - your dockerhub password
