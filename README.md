# Kubernetes Liatrio web service submission

### RUN LOCALLY

```console
$ git clone https://github.com/darenjacobs/k8s_flask_app.git
$ pip3 install flask
$ python3 app.py
```
visit http://127.0.0.1:5000/ in your web browser


### PREREQUISITES
```console
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
$ gcloud components install gke-gcloud-auth-plugin
```

### CLOUD DEPLOYMENT

edit line 2 of main.tf to point it to the location of your credentials file
```console
$ terraform init
$ terraform apply
```

### AUTOMATED TESTING
After deployment terraform will automatically check the status of the service to validate that it returns a 200 response
