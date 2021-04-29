# Invite Users to IBM Cloud Account

This tile invites users to the IBM Cloud account.

## Cloud-Native Toolkit

You can find out more information about the Cloud-Native Toolkit and the Iteration Zero terraform here:
    
- [IBM Garage Cloud Native Toolkit](https://cloudnativetoolkit.dev/)
- [Toolkit Iteration Zero Terraform](https://github.com/cloud-native-toolkit/ibm-garage-iteration-zero)

## Prerequisites

### IBM Cloud API key

An IBM Cloud API key for a user with sufficient authority to provision the SRE tool services into the resource group. API keys are
specific to an account, so a new API key will be needed for each account. Instructions for creating an API key can be 
found at [https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key](https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)

## Installation options

|Variable                  |Description|Example value|
|--------------------------|-----------|-----|
|users                     |Comma-separated list of users to add to the account |my-resource-group|
|ibmcloud_api_key          |The IBM Cloud API key that has enough access to provision the SRE tools services|{API KEY}|
