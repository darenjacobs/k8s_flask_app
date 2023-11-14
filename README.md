# Kubernetes Liatrio web service submission

### FLASK APP
```
Written in Python app.py listens on port 5000 to display the JSON text:
{
“message”: “Automate all the things!”,
“timestamp”: 1529729125
}
```

# USER GUIDE

Clone this Repository:
```console
$ git clone https://github.com/darenjacobs/k8s_flask_app.git
```

Please note:
* It is assumed that you possess a Google Cloud Platform (GCP) account and have the necessary access to the GCP API.
* If not you may need to install [Google Cloud SDK](https://cloud.google.com/sdk/docs/install).
* To run the Flask locally, Python3 is required.

Edit line 2 of main.tf to point it to the location of your credentials file.

Edit line 3 of main.tf entering your GCP project

### RUN THE FLASK APP LOCALLY
This simulates an on-premises installation
```console
$ pip3 install flask
$ python3 app.py
```
visit http://127.0.0.1:5000/ in your web browser


### SINGLE COMMAND
```console
$ bash launch.sh
```

Running the script launch.sh performs the PREREQUISITES and CLOUD DEPLOYMENT



### PREREQUISITES
```console
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
$ gcloud components install gke-gcloud-auth-plugin
```

### CLOUD DEPLOYMENT

```console
$ terraform init
$ terraform apply
```

### AUTOMATED TESTING
After deployment Terraform will automatically check the status of the service to validate that it returns a 200 response



### USE THE APP
The ultimate result from Terraform yields the public IP. Execute a cURL command using that IP.
```
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
$ terraform destroy -auto-approve
```
