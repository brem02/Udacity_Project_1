# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.
This is a project related to Udacity Azure DevOps nanodegree. The goal is to deploy a policy and an image from a Packer template that will be used by Terraform.
This project will also deploy a set number of virtual machines (default is 3) behind a load balancer, and sets up all other resources that need to be deployed for those virtual machines such as network security groups. The VM's are only accessible through the internal network, Virtual Networks, Subnets and Virtual Nics.

### Getting Started
1. Clone this repository
2. Create your infrastructure as code
3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
Create a resource group:
------------------------
Either from the portal or the CLI, create a new resource group or the project.

Deploy the policy and assign it to the resource group.

Deploy the Packer image:
-------------------------
$ packer build server.json

Prepare with Terraform:
-----------------------
The terraform file creates the following resources:
resource group
virtual network
subnet
network security group limiting access
network interfaces
a public ip
load balancer
availability set for the virtual machines
Linux virtual machines (3 by default)
1 managed disk per instance

$ terraform init -> to prepare your directory for terraform

Modify:
The file terraform/vars.tf contains all the variables used inside the terraform/main.tf. If you want to personalize the code, it is likely, those values you want to modify first. The vars.tf file contains the variables for the resource group name, prefix for most resources, number of vm's to create, and location. If number of VM's and location are not specified they will be set default to 3 instances and Canada East, respectively. You will need to change the packer_resource_group variable if you used a different resource group name for the packer image.
Review the main.tf to confirm that it is creating the correct resources for your project.

$ terraform plan -out solution.plan  --> to show the changes terraform will be making

$ terraform apply "solution.plan"  --> Deploy with Terraform and apply these changes:

$ terraform destroy  --> If you no longer need the resources destroy the infrastructure with this command in order to remove all the ressources


### Output
The following will be the output by terraform if you have executed the terraform plan command and the same output will be generated when using the terraform apply command:
