# Cloud-Native Toolkit

This tile provisions installs the Cloud-Native Toolkit DevSecOps tools into an existing cluster and optionally connects
the cluster to existing instances of LogDNA and Sysdig.

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

### Cluster provisioning

#### Public and private vlans for Classic infrastructure

Virtual local area networks (VLANs) are used by IBM Cloud® to isolate broadcast traffic on the public and private 
networks. Public and private vlans are needed to provision a cluster with classic infrastructure. Instructions for creating
a vlan can be found at [https://cloud.ibm.com/docs/cli?topic=cli-manage-classic-vlans#sl_vlan_create](https://cloud.ibm.com/docs/cli?topic=cli-manage-classic-vlans#sl_vlan_create) 

### (Optional) LogDNA instance

If you want to connect the cluster to an existing LogDNA instance then two pieces of information about the provisioned service are required:

- **logdna_name** - the name of the provisioned LogDNA service
- **logdna_region** - the region where the LogDNA service was provisioned

### (Optional) Sysdig instance

If you want to connect the cluster to an existing Sysdig instance then two pieces of information about the provisioned service are required:

- **sysdig_name** - the name of the provisioned Sysdig service
- **sysdig_region** - the region where the Sysdig service was provisioned

### (Optional) Image Registry configuration

The image registry can be configured in the cluster (and possibly configured within the image registry as well) during the
toolkit install process. The type of image registry will dictate what configuration values are required.

|Variable          |`icr` registry type|`ocp` registry type|`other` registry type|
|------------------|:-----------------:|:-----------------:|:-------------------:|
|registry_namespace|optional           |no                 |required             |
|registry_host     |no                 |no                 |required             |
|registry_user     |no                 |no                 |required             |
|registry_password |no                 |no                 |required             |
|registry_url      |no                 |no                 |required             |

### (Optional) Source Control configuration

The source control host can also be configured in the cluster. There are two variables required to configure
the source control repository:

- **source_control_type** - the type of source control system (github, gitlog, none)
- **source_control_url** - the url of the soruce control system (root url or git org)

## Installation options

|Variable                  |Description|Example value|
|--------------------------|-----------|-----|
|ibmcloud_api_key          |The IBM Cloud API key that has Cluster Admin access to the cluster and enough permission to access the LogDNA and Sysdig instances (if connecting the services)|{API KEY}|
|resource_group_name       |Existing resource group where the cluster will be provisioned                    |my-resource-group|
|region                    |The region where the cluster will be provisioned                                 |us-south|
|cluster_name              |The name that will be given to the cluster                                       |my-cluster|
|cluster_type              |The type of cluster that will be provisioned                                     |ocp45|
|vpc_cluster               |Flag indicating that the cluster has been built on VPC infrastructure            |true|
|logdna_region             |The region where the LogDNA instance has been provisioned                        |us-south|
|logdna_name               |The name of the existing LogDNA instance to which the cluster should be connected|my-resource-group-logdna|
|sysdig_region             |The region where the Sysdig instance has been provisioned                        |us-south|
|sysdig_name               |The name of the existing Sysdig instance to which the cluster should be connected|my-resource-group-sysdig|
|private_vlan_id           |The existing private vlan id that should be used by the cluster                  |2440701|
|public_vlan_id            |The existing public vlan id that should be used by the cluster                   |2440699|
|vlan_datacenter           |The datacenter where the public and private vlans exist                          |dal10|
|vpc_zone_count            |The number of vpc zones to include in the cluster.                               |3|
|flavor                    |The machine flavor that should be provisioned for each worker node               |m3c.4x32|
|cluster_worker_count      |The number of worker nodes that will be created in each VPC zone                 |3|
|registry_type             |The type of image registry (icr, ocp, other, none)                               |ocp|
|registry_namespace        |The namespace for image in the image registry                                    |test|
|registry_host             |The host for the image registry (needed for other registry types)                |docker.io|
|registry_user             |The username for the image registry (needed for other registry types)            |myuser|
|registry_password         |The password for the image registry (needed for other registry types)            |mypassword|
|registry_url              |The browser url for the image registry (needed for other registry types)         |https://hub.docker.com/u/test|
|source_control_type       |The type of source control system (github, gitlab, none)                         |github|
|source_control_url        |The url of source control system                                                 |https://github.com|
