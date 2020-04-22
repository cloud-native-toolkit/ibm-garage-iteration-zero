#!/bin/bash
# --------------------------------------------------------------------------------------------------------
# Name : Account Manager Access Group Policies
#
# Description: Add policies to an access group that allow management of an IBM Cloud account
# so it can be set up with resource groups and access groups that will allow access to
# Developer Environments created by the Cloud Native Toolkit.
#
# --------------------------------------------------------------------------------------------------------
#
# input validation
if [ -z "$1" ]; then
    echo "Usage: acp-mgr.sh <ACCESS_GROUP>"
    echo "Add account management policies to an access group"
    echo "<ACCESS_GROUP> - The name of the access group (ex: ACCOUNT-MGR)"
    exit
fi

ACCESS_GROUP=$1

# input validation
if [ -z "${ACCESS_GROUP}" ]; then
    echo "Usage: acp-mgr.sh <ACCESS_GROUP>"
    echo "Please provide the name of the access group (ex: ACCOUNT-MGR)"
    exit
fi


# Define the Polices for the Access Group to enable managing an account

# ACCOUNT MANAGEMENT POLICIES

# This doc explains the range of account management services and how to enable them:
# "Assigning access to account management services"
# https://cloud.ibm.com/docs/iam?topic=iam-account-services

# "Who can create resource groups?"
# https://cloud.ibm.com/docs/resources?topic=resources-resources-faq#create-resource
# All account management services - 38
# Grant access to all account management services
# This policy alone essentially gives the users all the permissions of the account owner (except classic infrastructure and Cloud Foundry permissions)
# Includes permissions to create resource groups, manage users, and create access groups
#ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --account-management --roles Administrator

# This command grants resource group abilities only, not the rest of account management abilities
# All resource group - 38
# Grant access to create and view resource groups
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --resource-type "resource-group" --roles Administrator

# "Inviting users to an account"
# https://cloud.ibm.com/docs/iam?topic=iam-iamuserinv#invite-access
# User Management service - 41
# Grant access to invite and view users
# Redundant with --account-management but independent of --resource-type "resource-group"
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --service-name user-management --roles Editor

# "Setting up access groups"
# https://cloud.ibm.com/docs/iam?topic=iam-groups
# IAM Access Groups Service service - 43
# Grant access to create and view access groups
# Redundant with --account-management but independent of --resource-type "resource-group"
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --service-name iam-groups --roles Editor


# IAM SERVICES POLICIES
# Similar to env admin policies, but for all resource groups
# Enables acct admin access to all resources in all regions and all resource groups

# "Managing user access with Identity and Access Management"
# https://cloud.ibm.com/docs/Registry?topic=registry-iam
# Container Registry service in All regions - 64
# Manager role grants access to create namespaces for the environment in the image registry
# Administrator role is needed to create clusters
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --service-name container-registry --roles Administrator,Manager

# "Prepare to create clusters at the account level"
# https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare
# Kubernetes Service service in All regions - 45
# Administrator role grants access to create and delete clusters, plus more
# Manager role grants access to manage clusters
# To create clusters, the user will also need Administrator access to the image registry
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --service-name containers-kubernetes --roles Administrator,Manager

# https://cloud.ibm.com/docs/iam?topic=iam-userroles
# All resources in account (including future IAM enabled services) in All regions - 40
# Administrator role grants access to create and delete service instances (any IAM service), plus more
# Manager role grants access to manage service instances
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --roles Administrator,Manager


echo "Completed creating polices!"