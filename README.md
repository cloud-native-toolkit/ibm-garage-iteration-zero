# IBM Garage for Cloud & Solution Engineering
## Iteration Zero for IBM Cloud
This repository contains tools and Terraform infrastructure as code (IasC) to help setup an IBM Cloud Public development
environment ready for cloud native application development with IBM Cloud Kubernetes Service or Red Hat OpenShift for IBM Kubernetes Service. 

### Overview

Iteration Zero has been designed to help a team configure a set of popular open source tools that can enable cloud native development. Typically a squad lead or lead developer would use this Terraform package after the initial inception workshop has completed and the development team is ready to write code. The objective and goal of this is to reduce the amount of time a team needs to configure and prepare their Kubernetes or OpenShift development environments. Some key benifits of Iteration Zero is that it makes the whole development lifecycle for IKS and OpenShift much smoother and easier than using the out of the box experience. Using Terraform enables it to be modular in configuration so tools can be easily disabled or new tools added. This combindation of tools are proven in the industry to deliver real value for modern cloud native development. 

The Red Hat Innovation Lab has a very similar approach to how they deliver success with OpenShift, view their approach [here](https://github.com/rht-labs/labs-ci-cd).

This repo contains Terraform resources that will deploy the following development tools into your IKS or OpenShift infrastructure.

- IBM Container Service Cluster (3 nodes) for IKS or OpenShift
- Create *dev*,*test*,*staging* and *tools* namespaces
- Install the following tools:
    - [Jenkins CI](https://jenkins.io/)
    - [Argo CD](https://argoproj.github.io/argo-cd/)
    - [SonarQube](https://www.sonarqube.org/) 
    - [Pack Broker](https://docs.pact.io/)
    - [Artefactory](https://jfrog.com/open-source/)
    - [Eclipse CHE](https://www.eclipse.org/che/)

- Create and bind the following Cloud Services to your Cluster:
    - [AppID Application Authentication](https://cloud.ibm.com/docs/services/appid?topic=appid-service-access-management) 
    - [Cloudant NoSQL Database](https://cloud.ibm.com/docs/services/Cloudant?topic=cloudant-getting-started)
    - [Cloud Object Storage Storage](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-getting-started)
    - [LogDNA Logging](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started)
    - [SysDig Monitoring](https://cloud.ibm.com/docs/services/Monitoring-with-Sysdig?topic=Sysdig-getting-started)
    - [PostgreSQL](https://cloud.ibm.com/docs/services/databases-for-postgresql?topic=databases-for-postgresql-about) (used by SonarQube)

## Development Tools

![Provisioned environment](./docs/images/catalyst-provisioned-environment.png)

**Warning: The material contained in this repository has not been thoroughly tested. Proceed with caution and report any issues you find.**

***
## Deploying with Terraform
This section discusses deploying IBM Cloud resources with Terraform. This section uses the [Garage Catalyst Docker Image](https://cloud.docker.com/u/garagecatalyst/repository/docker/garagecatalyst/ibm-garage-cli-tools) to run the Terraform client.

**NOTE:** The terraform scripts can be run to create a new Kubernetes cluster or modify an
existing cluster. If an existing cluster is selected, then any existing namespaces named 
`tools`, `dev`, `test`, and `staging` and any resources contained therein will be destroyed.

**Warning: This has only been tested on MacOS.**

## Pre-requisites
The following pre-requisties are required before following the setup instructions. 

- An IBM Cloud account with: 
    - the ability to provision resources to support Kubernetes environment
    - a [Resource Group](https://cloud.ibm.com/account/resource-groups) for your development resources
    - a Public and Private VLAN
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running on your local machine
- [Node](https://nodejs.org/en/) installed on your local machine

## Installation

### Step 1. Creating Resource Group
The first step is to create a dedicated Resource Group for your development team. This Resource Group will contain your 
development cluster and supporting cloud services. Using the Cloud Console create a unique 
[Resource Group](https://cloud.ibm.com/account/resource-groups). 


### Step 2. Clone this repository to your local filesystem

```bash
$ git clone git@github.ibm.com:garage-catalyst/iteration-zero-ibmcloud.git

$ cd iteration-zero-iks
```

### Step 3. Create the credentials.properties file

Use these [instructions to generate keys and configure the credenitals.properties file](./docs/APIKEYS.md). 


### Step 4. Get the the VLAN Information into the terri=aform variables file

Use these [instructions to obtain the VLAN configuration and persist in terraform variables](./docs/VLAN.md).

### Step 5. Run Terraform to provision Development Cluster and Tools
- Run the following command to launch a Garage [Catalyst CLI Tools Docker container](https://github.ibm.com/garage-catalyst/client-tools-image).

    ```bash
    $ ./launch.sh
    ```
    ***NOTE:*** This will install the Cloud Garage Tools docker image and exec shell into the running container. You will run the rest of the commands from inside this container. The container will mount the `./terraform/` directory as `/home/devops/src/`. This is helpful in sharing files between your host filesystem and your container. 

    It will also allow you to continue to extend or modify the base Terraform IasC that has been supplied and tailor it for your specific project needs.

### Step 6. Deploy the Iteration Zero Resources
- Run the following commands:
    ```bash
    $ ./runTerraform.sh
    ```

    The script will prompt if you want to create a new cluster or use an existing cluster. If an existing cluster is selected the contents will be cleaned up to prepare for the terraform process (the `tools`, `dev`, `test`, and `staging` namespaces).

    After that the Terraform Apply process and begin to create the infrastructure and services for your Development Enviroment.

    Creating a new cluster takes about 1.5 hours on average (but can also take considerably longer) and the rest of the process takes about 30 minutes. At the end, you should have your Iteration Zero resources fully provisioned and configured, enjoy!

***
## Usage

### Development Cluster Dashboard

To make it easy to navigate to the installed tools, there is a simple dashboard that has been deployed that can help you navigate to the consoles for each of the tools.

To access the dashboard take the the ingress subdomain from the Cluster and prefix it with the word `dashboard`. 

```bash
https://dashboard.catalyst-dev-cluster.us-south.containers.appdomain.cloud

````
This will present you with the following dashboard.

![Dashboard](./docs/images/devcluster.png)

Currently the tools are not linked to a single sign on (future plan), other than Jenkins in OpenShift, to obtain the credentials for the tools login into ibm cloud account on the command line and run `igc credentials` this will list the userids and passwords secrets for each tool installed.

```bash
ibmcloud login -a cloud.ibm.com -r us-south -g catalyst-team
igc credentials
```

### Operations

Now that your development cluster is configured you can now register `LogDNA` and `SysDig` service instances with your Kubernetes cluster. 

Navigate to the Observability menu from the main console menu and then click on the `Edit Sources` and follow the instructions to configure the log agent and montitoring agents for you development cluster. 

### Deploying Code into Pipelines

Now you have a working development environment on the IBM Public Cloud. You can now start working with code to deploy into your cluster using Jenkins pipelines. The following instructions help describe this process.

You can click on the `Starter Kits` tab on the Development Cluster Dashboard and follow the instructions for provisioning a new microservice into your development cluster. You can easily create an microservice by using the github templates listed below:

* [12 UI Patterns with React and Node.js](https://github.com/ibm-garage-cloud/template-node-react)
* [TypeScript Microservice or BFF with Node.js](https://github.com/ibm-garage-cloud/template-node-typescript)
* [GraphQL BFF with Node.js](https://github.com/ibm-garage-cloud/template-graphql-typescript)
* [Spring Boot Java Microservice](https://github.com/ibm-garage-cloud/template-java-spring)

Click on the `Use this template` button to create a repo in your git organisation. Then follow the pipeline registration instructions below, you will need to be logged into the OpenShift Console or IKS clusters on the command line. You will also need a [Personal Access Token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) from your git organistaion.

```bash
git clone <generated startkit template>
cd <generated startkit template>
vi package.json ! rename template
git add .
git commit -m "Rename project"
git push
igc register ! register pipeline with Jenkins
? Please provide the username for https://github.com/mjperrins/hello-world-bff.git: mperrins
? Please provide your password/personal access token: [hidden]
? Please provide the branch the pipeline should use: master
Creating git secret
Copying 'ibmcloud-apikey' secret to dev
Registering pipeline
? The build pipeline (mjperrins.hello-world-bff) already exists. Do you want to update it? (Y/n)
```

The pipeline will be created in the `dev` namespace in OpenShift and IKS, it will create any necessary secrets required to run the pipeline. The app image will be stored in the IBM Container Registry and deployed into the `dev` name space. You can use the Argo CD Template to help define a deployment configuration from `dev` to `test` and `staging`

If you want to get easy access to your application routes or ingress end points for your apps run the following command. All the `igc` commands run the same on IKS and OpenShift.
```bash
igc ingress -n dev
```
***
## Summary

We are working to make Kubernetes and OpenShift development as easy as possible, any feedback on the use of the project will be most welcome.

Thanks Catalyst Team

### Destroying
Once your development tools are configured Terraform stores the state of the creation in the `workspace` folder. 

It is is possible to destory the development environment following these steps.

Run the following command to launch a Garage Catalyst CLI Tools Docker container.
```bash
./launch.sh
```
Follow these instructions to run the terraform tool from your `workspace` directory.
```bash
cd workspace
terraform destroy
```
This will remove the development cluster and all the services that were created previously.

## Possible Issues

If you find that that the Terraform provisioning has failed try re-running the `runTerraform.sh` script again. The state will be saved and Terraform will try and apply the configuration to match the desired end state.

If you find that some of the services have failed to create in the time allocated. You can manually delete the instances in your resource group. You can then re-run the `runTerraform.sh` but you need to delete the `workspace` directory first. This will remove any state that has been created by Terraform. 

```bash
rm -rf workspace
```
