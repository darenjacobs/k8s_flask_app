# Kubernetes Flask App


# USER GUIDE

Clone this Repository:
```console
git clone https://github.com/darenjacobs/k8s_flask_app.git
```

TLDR:
Edit flask-app/values.yaml and set your app repository name.
The easiest way to deploy the Flask App is to [SET GITHUB ACTIONS SECRETS](#set-secrets) and commit to the branch.




### ABOUT THE FLASK APP
```
Written in Python app.py listens on port 8080 to display the JSON text:
{
“message”: “Hello World! - Automate all the things!”,
“timestamp”: 1529729125
}
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
  "message": "Hello World! - Automate all the things!",
  "timestamp": 1699943619
}
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
 - SA_CREDENTIALS - JSON credentials for the service account with at least "Kubernetes Engine Developer" permissions

AWS:
 - AWS_ACCESS_KEY - Access Key ID to service account with permissions to create an EKS cluster
 - AWS_SECRET_KEY - Secret Access key to a service account with permissions to create an EKS  cluster

Azure:
 - AZURE_CREDENTIALS - Service Principal credentials with contributor access to your subscription
