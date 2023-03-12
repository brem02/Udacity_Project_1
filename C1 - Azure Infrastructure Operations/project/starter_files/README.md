# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.
This is a project related to Udacity Azure DevOps nanodegree. It aims at deploying a policy, an image from a Packer template that will be used by Terraform.

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
Export the variable:
Add to your .bashrc (or .zshrc) file:
export AZ_CLIENT_ID=00000000-0000-0000-0000-000000000000
export AZ_CLIENT_SECRET=000000000000000000000
export AZ_TENANT_ID=00000000-0000-0000-0000-000000000000
export AZ_SUSCRIPTION_ID=00000000-0000-0000-0000-000000000000

Create a resource group:
Either from the portal or the CLI, create a new resource group or the projet, in my case it is udacity-assignment1-rg.

Deploy the policy and assign it to the resource group.

Deploy the Packer image:
$ packer build packer/server.json

Prepare with Terraform:
$ terraform init
$ terraform plan -out solution.plan

Deploy with Terraform:
$ terraform apply "solution.plan"

After that destroy the infrastructure with:
$ terraform destroy

Modify:
The file terraform/vars.tf contains all the variables used inside the terraform/main.tf. If you want to personnalize the code, it is likely those values you want to modify first.

### Output
**Your words here**
