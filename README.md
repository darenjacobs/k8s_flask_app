# Kubernetes Liatrio web service submission

### RUN LOCALLY

```
$ git clone https://github.com/darenjacobs/k8s_flask_app.git
$ pip3 install flask
$ python3 app.py

visit http://127.0.0.1:5000/ in your web browser
```

### INSTALL TERRAFORM
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### INSTALL GOOGLE CLOUD PLUGIN
```
gcloud components install gke-gcloud-auth-plugin
```

### CLOUD DEPLOYMENT

```
edit line 2 of main.tf replacing the credentials line with your GCP credentials
terraform init
terraform apply
