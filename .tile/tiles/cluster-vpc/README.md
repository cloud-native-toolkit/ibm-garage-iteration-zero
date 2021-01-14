# Cloud-Native Toolkit SRE Tools

This tile provisions a cluster in the IBM Cloud account using VPC infrastructure. It supports provisioning either an IKS 
or ROKS 3.11, 4.3, 4.4, or 4.5 clusters.

## Cloud-Native Toolkit

You can find out more information about the Cloud-Native Toolkit and the Iteration Zero terraform here:
    
- [IBM Garage Cloud Native Toolkit](https://cloudnativetoolkit.dev/)
- [Toolkit Iteration Zero Terraform](https://github.com/ibm-garage-cloud/ibm-garage-iteration-zero)

This tile is a piece of a larger Cloud-Native Software Development LifeCycle (SDLC) to enable end-to-end development and management of Cloud-Native applications

![CNCF DevOps Tools](https://raw.githubusercontent.com/ibm-garage-cloud/ibm-garage-iteration-zero/master/docs/images/catalyst-provisioned-environment.png)

## Prerequisites

### Resource group

An existing resource group is needed to identify the collection of resources. It is **highly** recommended not to use the `default` resource group.
Instructions for creating a resource group can be found at [https://cloud.ibm.com/docs/account?topic=account-rgs](https://cloud.ibm.com/docs/account?topic=account-rgs)

### IBM Cloud API key

An IBM Cloud API key for a user with sufficient authority to provision the SRE tool services into the resource group. API keys are
specific to an account, so a new API key will be needed for each account. Instructions for creating an API key can be 
found at [https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key](https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)

## Installation options

|Variable                  |Description|Example value|
|--------------------------|-----------|-----|
|ibmcloud_api_key          |The IBM Cloud API key that has enough access to provision VPC infrastructure and the cluster|{API KEY}|
|resource_group_name       |Existing resource group where the cluster will be provisioned                   |my-resource-group|
|region                    |The region where the cluster will be provisioned                                | "us-south", "us-east", "eu-de", "eu-gb", "au-syd", or "jp-tok" |
|cluster_name              |The name that will be given to the cluster                                      |my-cluster|
|cluster_type              |The type of cluster that will be provisioned                                    |ocp45
|vpc_zone_count            |The number of vpc zones that will be provisioned in the cluster.                |3|
|flavor                    |The machine flavor that should be provisioned for each worker node              |m3c.4x32|
|cluster_worker_count      |The number of worker nodes that will be created in each VPC zone                |3|
