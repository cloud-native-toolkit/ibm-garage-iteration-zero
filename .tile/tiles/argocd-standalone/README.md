# ArgoCD Production

This tile provisions ArgoCD in a stand alone mode to enable the configuration of GitOps in a production cluster.

## Cloud-Native Toolkit - ArgoCD

You can find out more information about the Cloud-Native Toolkit and the Iteration Zero terraform here:
    
- [IBM Garage Cloud Native Toolkit](https://cloudnativetoolkit.dev/)
- [Toolkit Iteration Zero Terraform](https://github.com/ibm-garage-cloud/ibm-garage-iteration-zero)

This tile is a piece of a larger Cloud-Native Software Development LifeCycle (SDLC) to enable end-to-end development and management of Cloud-Native applications this tile specifically installs ArgoCD to enable stand alone GitOps within a production cluster

## Prerequisites

### Resource group

An existing resource group is needed to identify the collection of resources. It is **highly** recommended not to use the `default` resource group.
Instructions for creating a resource group can be found at [https://cloud.ibm.com/docs/account?topic=account-rgs](https://cloud.ibm.com/docs/account?topic=account-rgs)

### IBM Cloud API key

An IBM Cloud API key for a user with sufficient authority to provision the SRE tool services into the resource group. API keys are
specific to an account, so a new API key will be needed for each account. Instructions for creating an API key can be 
found at [https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key](https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)

### Cluster

A managed cluster must have already been provisioned. The tile will need four pieces of information about the cluster:

- **cluster name** - the name given to the cluster
- **cluster type** - the type of cluster that was provisioned (kubernetes or ocp4)
- **region** - the region where the cluster was provisioned
- **vpc_cluster** - a flag indicating if the cluster uses VPC infrastructure (true) or Classic infrastruture (false)

## Installation options

|Variable                  |Description|Example value|
|--------------------------|-----------|-----|
|ibmcloud_api_key          |The IBM Cloud API key that has Cluster Admin access to the cluster and enough permission to access the LogDNA and Sysdig instances (if connecting the services)|{API KEY}|
|resource_group_name       |Existing resource group where the cluster will be provisioned                    |my-resource-group|
|region                    |The region where the cluster will be provisioned                                 |us-south|
|cluster_name              |The name that will be given to the cluster                                       |my-cluster|
|cluster_type              |The type of cluster that will be provisioned                                     |ocp45|
|vpc_cluster               |Flag indicating that the cluster has been built on VPC infrastructure            |true|
