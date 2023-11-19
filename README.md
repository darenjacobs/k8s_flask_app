# Kubernetes Flask App

### FLASK APP
```
Written in Python app.py listens on port 8080 to display the JSON text:
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

Login to your Azure account
az login

### RUN THE FLASK APP LOCALLY
This simulates an on-premises installation
```console
$ pip3 install flask
$ python3 app.py
```
visit http://127.0.0.1:8080/ in your web browser


### SINGLE COMMAND
```console
$ bash launch.sh
```

Running the script launch.sh performs the PREREQUISITES and CLOUD DEPLOYMENT



### PREREQUISITES
```console
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
```

### CLOUD DEPLOYMENT

```console
$ terraform init
$ terraform plan
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
