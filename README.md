# Solution for the [DevOps Kata, Kata 1](https://devops-kata.github.io/)

* Provisions a server image with Packer and Ansible
* Creates an AWS infra with Terraform

See the [denyago/sample-rails-app](https://github.com/denyago/sample-rails-app) for a Docker'ised Ruby on Rails app to be deployed into the infra.

## Running

### Configure

Use a separate profile, if you have multiple accounts.
If not, just don't set this option and avoid the environment variable.

`aws configure --profile devops-kata`

### Create a new AMI

```bash
cd ami
AWS_PROFILE=devops-kata ./build.sh
```

...the job will return the image ID. Add it to the variables file (`infra.tfvars`) on the next step.

*Costs may apply!* Storing your AMI costs money.
If you are experimenting, make sure you de-register AMI and destroy it's snapshot.

### Create a new AWS infrastructure

Ensure that you have an SSH key pair in AWS. When you create it, save the name to `infra.tfvars`:

```
app_servers_ssh_key_name = "<your SSH key pair here>"
app_server_ami_id = "<your AMI image ID here>"
```

Plan the changes (not mandatory):

```bash
cd terraform
AWS_PROFILE=devops-kata terraform plan -var-file=infra.tfvars
```

Apply (resources will be created in the cloud):

```bash
AWS_PROFILE=devops-kata terraform apply -var-file=infra.tfvars
```

*Costs may apply!* Don't forget to destroy, what your are not using:

```bash
AWS_PROFILE=devops-kata terraform destroy -var-file=infra.tfvars
```
