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
Written in Python app.py listens on port 8080 to display the JSON text:
{
“message”: “Automate all the things!”,
“timestamp”: 1529729125
}
```


### RUN THE FLASK APP LOCALLY

Please note:
* It is assumed that you possess a Google Cloud Platform (GCP) account and have the necessary access to the GCP API.
* If not you may need to install [Google Cloud SDK](https://cloud.google.com/sdk/docs/install).
* To run the Flask locally, Python3 is required.

Edit line 2 of main.tf to point it to the location of your credentials file.

Edit line 3 of main.tf entering your GCP project


This simulates an on-premises installation
```console
pip3 install flask
python3 app/app.py
```
visit http://127.0.0.1:8080/ in your web browser


### MANUAL CLOUD DEPLOYMENT
```console
bash launch.sh
```

Running the script launch.sh performs the PREREQUISITES and CLOUD DEPLOYMENT

### PREREQUISITES
```console
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
gcloud components install gke-gcloud-auth-plugin
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

The ultimate result from Terraform yields the public IP. Execute a curl command using that IP.  Output is similar to the following:

data.http.my_app_service: Reading...
data.http.my_app_service: Read complete after 0s [id=http://PUBLIC_IP/]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
$ curl http://PUBLIC_IP/
{
  "message": "Automate all the things!",
  "timestamp": 1699943619
}
```

### MANUALLY TEST ENDPOINT
```console
bash page_test.sh
```

### DELETE THE APP & CLUSTER
```console
terraform destroy -auto-approve
```


## CI / CD Pipelines

Any commits to the branches will start the pipeline which will test the app, deploy the app to Docker Hub, create a K8s cluster in the respective Cloud provider, and deploy the app to the cluster.

Checkout the "main" branch for GCP (GKE), the "aws" branch for AWS (EKS), or the "azure" branch for Azure (AKS)


# SET SECRETS
In Github (Settings - Secrets and variables - Actions) set the following secrets:

- DOCKER_NAME - flask-app
- DOCKER_USERNAME - your dockerhub username
- DOCKER_PASSWORD - your dockerhub password

Cloud Provider Secrets:

GCP:
 - GKE_PROJECT_ID - GKE project ID
 - SA_CREDENTIAL - JSON credentials for the service account with at least "Kubernetes Engine Developer" permissions

AWS:
 - AWS_ACCESS_KEY - Access Key ID to service account with permissions to create an EKS cluster
 - AWS_SECRET_KEY - Secret Access key to a service account with permissions to create an EKS  cluster

Azure:
 - AZURE_CREDENTIAL - Service Principal credentials with contributor access to your subscription
