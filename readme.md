# Example ECS Fargate environment built with Terraform

This repo contains both the **IAC** (Terraform) and a sample **Dockerfile** (NGINX) to deploy an ECS Fargate environment to AWS with TLS(SSL) configured.

## Prerequisites
* AWS Account
	* IAM User with permissions to create resources
	* Access and Secret keys for IAM user
	* S3 bucket manually provisioned to hold Terraform state file. Example: `myapp-terraform-backend`
	* Route53 Hosted Zone used to create CNAME and TLS verification entries
* [Terraform executable](https://www.terraform.io/downloads.html) in your Path
* [Docker](https://www.docker.com/products/docker-desktop) installed locally, or access to a docker instance to build the container
* [AWS CLI](https://aws.amazon.com/cli/) installed in order to push Docker image to ECR


## Instructions
### Create ECS Environment
* Clone this repository: `git clone https://github.com/cashman04/ecs-fargate-terraform`
* Change directory to iac folder: `cd ecs-fargate-terraform/iac`
* Create a `terraform.tfvars` file and populate the following variables:
	* `aws_access_key =  "***"` Your IAM User access key
	* `aws_secret_key = "***"` Your IAM User secret key
	* `aws_region = "***"`  AWS Region(note, if you change this from us-east-2 you will need to also set an: `availability_zones` variable as well.  See `iac/variables.tf` for other optional configs
	* `environment =  "dev"` Environment name
	* `name = "myapp"` Your App Name
	* `container_port =  80`  Port your docker image exposes. Example Docker image uses port 80
	* `hosted_zone =  "acme.com"`  Name of your hosted zone.  A CNAME entry will be create with `$name.$hosted_zone` pointing the Application Load Balancer serving your ECS Service
	* Modify `app\main.tf` and change backend `bucket` setting to your bucket name you wish to house the Terraform state file in(line 10):  `bucket =  "myapp-terraform-backend"`

* Initialize Terraform(for Bash CLI change ticks to forward slashes): 
	```
	terraform init -backend-config="bucket=myapp-terraform-backend" `
                   -backend-config="key=tf/state/terraform.tfstate" `
                   -backend-config="region=us-east-1" `
                   -backend-config="access_key=***" `
                   -backend-config="secret_key=***"
	```
Example output:
```                    
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 3.0"...
- Installing hashicorp/aws v3.59.0...
- Installed hashicorp/aws v3.59.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

* Create a Terraform plan
	```
	terraform plan -out myapp.tfplan
	```
Truncated example output:
```
Plan: 40 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: myapp.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "myapp.tfplan"
```
* Apply Terraform plan
	```
	terraform apply "myapp.tfplan"
	```
Truncated Example output:
```
Apply complete! Resources: 40 added, 0 changed, 0 destroyed.
```

### Deploy your docker image
Included in the output of the `terraform apply` are all of the next steps you will need to run in order to build a docker image, log in to your ECR, tag and push your image to your ECR, and then force a new deployment so that your ECS service will pull your newly pushed image.

Example output:
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

Next_Steps = <<EOT
Next Steps to deploy example docker container to ECS:

  Docker Build(from app directory):
      docker build . -t myapp


  Login to ECR:
      aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 548698725178.dkr.ecr.us-east-2.amazonaws.com/myapp-dev-ecr


  Tag Docker image with ECR:
      docker tag myapp 548698725178.dkr.ecr.us-east-2.amazonaws.com/myapp-dev-ecr


  Push Docker image to ECR:
      docker push 548698725178.dkr.ecr.us-east-2.amazonaws.com/myapp-dev-ecr


  Force new ECS service deployment:
      aws ecs update-service --cluster myapp-dev-ecs --service myapp-dev-service --force-new-deployment


  Wait a short time and then visit your URL!
      myapp.acme.com
```