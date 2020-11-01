# Cloud-Native Toolkit SRE Tools

This tile installs a set of SRE Tools into a resource group in an IBM Cloud account. Typically, These tools will be
shared across different clusters and teams. This tile can be used to install those tools once on a central resource group
or multiple times into different resource groups, depending upon how the tools will be shared.

Additionally, the tile allows a selection of which individual tools to provision through the installation options. All of the tools
except for Activity Tracker have been configured to provision by default. Activity Tracker does not install by default because there are
limits on how many instances can be provisioned in the account.

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
|resource_group_name       |Existing resource group where the SRE tools will be provisioned                 |my-resource-group|
|region                    |The region where the SRE tools will be provisioned                              | "us-south", "us-east", "eu-de", "eu-gb", "au-syd", or "jp-tok" |
|ibmcloud_api_key          |The IBM Cloud API key that has enough access to provision the SRE tools services|{API KEY}|
|provision_logdna          |Flag indicating that the LogDNA instance should be provisioned                  |"true" or "false"|
|provision_sysdig          |Flag indicating that the Sysdig instance should be provisioned                  |"true" or "false"|
|provision_activity_tracker|Flag indicating that the Activity Tracker instance should be provisioned. Note, only one instance of Activity Tracker is allowed for each account|"true" or "false"|
|provision_key_protect     |Flag indicating that the Key Protect instance should be provisioned             |"true" or "false"|
|provision_object_storage  |Flag indicating that the Object Storage instance should be provisioned          |"true" or "false"|
|name_prefix               |The prefix that will be used to build the service names. If not provided the resource group name will be used as the prefix.|sre-tools|
