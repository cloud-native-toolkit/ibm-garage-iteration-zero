# startkit-terraform
This repository contains tools to help setup an IBM Cloud Public development environment.

**Warning: The material contained in this repository has not been thoroughly tested. Proceed with caution.**

## Basic Setup
This section will guide you through basic setup of the environment deployment. You will need access an account with the ability to provision on IBM Cloud Public before proceeding.

### Pre-requisites
- An IBM Cloud account with the ability to provision resources.
- A resource group, public VLAN, and private VLAN in IBM Cloud.
- Docker installed on your local development machine.

### Getting API Keys
There are two different API Keys that you will need to generate in order to deploy everything in this guide, one for IBM Cloud resources and another set for Classic Infrastructure resources.

To generate these keys, please visit the following links:
- [IBM Cloud](https://console.bluemix.net/docs/iam/userid_keys.html#creating-an-api-key "Creating an API key")
- [Classic Infrastructure](https://cloud.ibm.com/docs/iam?topic=iam-classic_keys#classic_keys "Managing classic infrastructure API keys")

The IBM Cloud API Key will later be referred to as: `BM_API_KEY`. The Classic Infrastructure Key will later be referred to as: `SL_API_KEY` and the Classic Infrastructure username for that Infrastructure Key is `SL_USERNAME`.

## Deploying with Terraform
This section discusses deploying IBM Cloud resources with Terraform. This section uses the [Garage Catalyst Docker Image](https://hub.docker.com/r/garagecatalyst/ibm-kube-terraform) to run the Terraform client.

### Overview

This repo contains Terraform resources that will deploy the following:

- IBM Container Service Cluster (3 nodes), with:
  - SonarQube
  - Jenkins
- PostgreSQL
- AppID
- Cloudant
- Cloud Object Storage

### Getting Started

Once you have followed the steps in the [Basic Setup](#basic-setup) section, clone this repository to your local filesystem and cd into the src/ directory.

```bash
$ git clone git@github.ibm.com:garage-catalyst/iteration-zero-terraform.git

$ cd iteration-zero-terraform
```

Next, modify the `pacakage.json` file to add your `BM_API_KEY`, `SL_USERNAME` and `SL_API_KEY`.
```json
...
"config": {
  "BM_API_KEY": "<YOUR_BM_API_KEY>",
  "SL_USERNAME": "<YOUR_SL_USERNAME>",
  "SL_API_KEY": "<YOUR_SL_API_KEY>"
},
...
```

Then, run the following command to launch a Garage Catalyst Tools Docker container.
```bash
$ npm run start
```

***NOTE:*** You will run the rest of the commands from inside this container. The container will mount the `./src/` directory as `/home/devops/src/`. This is helpful in sharing files between your host filesystem and your container.

### Deploying the Iteration Zero resources

Inside the container, you should find the Terraform parameters file as `/home/devops/src/workspace/terraform.tfvars`. Open this file for edit and fill out the parameters with appropriate values.
```bash
$ vi /home/devops/src/workspace/terraform.tfvars
```

For example, we have a resource group `catalyst-team` with private VLAN `2372`, public VLAN `1849` in the DAL10 datacenter. Our `terraform.tfvars` would look accordingly:
```terraform
resource_group_name           = "catalyst-team"
private_vlan_number           = "2372"
private_vlan_router_hostname  = "bcr01a.dal10"
public_vlan_number            = "1849"
public_vlan_router_hostname   = "fcr01a.dal10"
vlan_datacenter               = "dal10"
vlan_region                   = "us-south"
```

Save the file, then run the following commands:
```bash
$ cd /home/devops/src/workspace; \
  chmod +x runInstall.sh; \
  ./runInstall.sh
```

The resources will take about 2 hours to deploy. At the end, you should have your Iteration Zero resources fully provisioned and configured!
