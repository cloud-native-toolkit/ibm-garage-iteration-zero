# startkit-terraform
This repository contains tools to help setup an IBM Cloud Public development environment.

**Warning: The material contained in this repository has not been thoroughly tested. Proceed with caution.**

## Basic Setup
This section will guide you through basic setup of the environment deployment. You will need access an account with the ability to provision on IBM Cloud Public before proceeding.

### Pre-requisites
- An IBM Cloud account with the ability to provision resources.
- Docker installed on your local development machine.
- The IBM Cloud CLI installed on your local development machine.

### Getting API Keys
There are two different API Keys that you will need to generate in order to deploy everything in this guide, one for IBM Cloud resources and another set for Classic Infrastructure resources.

To generate these keys, please visit the following links:
- [IBM Cloud](https://console.bluemix.net/docs/iam/userid_keys.html#creating-an-api-key "Creating an API key")
- [Classic Infrastructure](https://cloud.ibm.com/docs/iam?topic=iam-classic_keys#classic_keys "Managing classic infrastructure API keys")

The IBM Cloud API Key will later be referred to as: `BM_API_KEY`. The Classic Infrastructure Key will later be referred to as: `SL_API_KEY` and the Classic Infrastructure username for that Infrastructure Key is `SL_USERNAME`.

## Deploying with Terraform
This section discusses deploying IBM Cloud resources with Terraform. This section uses the [IBM Terraform Docker image](https://hub.docker.com/r/ibmterraform/terraform-provider-ibm-docker/) to run the Terraform client.

### Overview

This repo contains Terraform templates as well as a couple of scripts to expedite the deployment process of the IBM Terraform Docker container. The templates are located in `src/tf/templates` and the scripts are in `src/scripts/tf`.

### Getting Started

Once you have followed the steps in the [Basic Setup](#basic-setup) section, clone this repository to your local filesystem and cd into the src/ directory.

```
$ git clone git@github.ibm.com:garage-catalyst/ibmcloud-public-dev-setup.git

$ cd ibmcloud-public-dev-setup/src
```

**Note: The scripts assume that you are running them from the `ibmcloud-public-dev-setup/src` directory.**

Next, deploy the IBM Terraform Docker Container. You will need your API Keys as defined in the [Getting API Keys](#getting-api-keys) section. Replace the `BM_API_KEY`, `SL_USERNAME` and `SL_API_KEY` parameters accordingly.

```
$ ./scripts/tf/launch.sh BM_API_KEY SL_USERNAME SL_API_KEY
$ cd tf
```

You will be given a shell inside the container. All commands that should be run inside this container will be prefixed with `[TF]`. Commands that should be run on your dev/host system will be prefixed with `[DV]`.

The container will mount the `src/tf` directory as `/bin/go/tf`. This is helpful in sharing files between your host filesystem and your container.

### Example: Deploy an AppID instance with Terraform
This section describes how to deploy an AppID instance using Terraform.

First, copy the AppID Terraform template to the `src/tf` directory.

```
[DV] $ cd ibmcloud-public-dev-setup/src
[DV] $ cp tf/templates/appid.tf.template tf/main.tf
```

Your `tf/main.tf` file should look like the following:
~~~
# tf/main.tf
data "ibm_resource_group" "appid_resource_group" {
  name = "${var.resource_group_name}"
}

resource "ibm_resource_instance" "appid_instance" {
  name              = "${data.ibm_resource_group.appid_resource_group.name}-appid"
  service           = "appid"
  plan              = "lite"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.appid_resource_group.id}"
}
~~~

You can see two variables and one resource above, where the resource references the two variables. These variables can be defined when you run the `terraform apply` command, but they can also be specified in a file.

We will proceed with defining the variables in a file. Create the `tf/terraform.tfvars` file and open for editing.
```
[DV] $ touch tf/terraform.tfvars
```

Then, paste the in the following:
~~~
# tf/terraform.tfvars
resource_group_name = "RG_NAME"
~~~

Variables used here will be the values for variables referenced in `tf/main.tf`. Change `RG_NAME` to an appropriate value. Where `RG_NAME` is the name of the Resource Group where you would like to deploy AppID.

Next, run the `terraform plan` command to see what Terraform will create.
```
[TF] $ terraform plan
```

You should see that Terraform will create the new AppID instance. Then, you can run the `terraform apply` command to actually create the AppID instance.
```
[TF] $ terraform apply
```


