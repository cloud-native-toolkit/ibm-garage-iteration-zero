#!/bin/bash
# --------------------------------------------------------------------------------------------------------
# Name: Environment User Access Group Policies
#
# Description: Add policies to an access group that allow user access to resources in
# a resource group. Don't allow create/delete of clusters and service instances, but do allow
# use of existing clusters and services, including changing their service-specific resources.
#
# --------------------------------------------------------------------------------------------------------
#
# input validation
if [ -z "$1" ]; then
    echo "Usage: acp-user.sh <ACCESS_GROUP> <RESOURCE_GROUP> <REGION>"
    echo "Add policies to an access group for using resources in a resource group"
    echo "<ACCESS_GROUP> - The name of the access group (ex: <RESOURCE_GROUP>-USER)"
    echo "<RESOURCE_GROUP> - The name of the resource group for the environment (ex: garage-apps)"
    echo "<REGION> - The name of the region for the environment (ex: us-south)"
   exit
fi

ACCESS_GROUP=$1
RESOURCE_GROUP=$2
REGION=$3

# input validation
if [ -z "${ACCESS_GROUP}" ]; then
    echo "Usage: acp-user.sh <ACCESS_GROUP> <RESOURCE_GROUP> <REGION>"
    echo "Please provide the name of the access group (ex: <RESOURCE_GROUP>-USER)"
    exit
fi

# input validation
if [ -z "${RESOURCE_GROUP}" ]; then
    echo "Usage: acp-user.sh <ACCESS_GROUP> <RESOURCE_GROUP> <REGION>"
    echo "Please provide the name of the resource group for the environment (ex: garage-apps)"
    exit
fi

# input validation
if [ -z "${REGION}" ]; then
    echo "Usage: acp-user.sh <ACCESS_GROUP> <RESOURCE_GROUP> <REGION>"
    echo "Please provide the name of the region for the environment (ex: us-south)"
    exit
fi


# Container registry does not currently support us-east region
if [ "${REGION}" == "us-east" ]; then
  echo "Changing region from us-east to us-south."
  REGION="us-south"
fi


# Define the Polices for the Access Group, this are limited to usage patterns not administration patterns

# "Managing user access with Identity and Access Management"
# https://cloud.ibm.com/docs/Registry?topic=registry-iam
# Container Registry service - 21
# Grant access to the image registry to use (push, pull, etc.) images in the environment's namespace
# The registry namespace for a Developer Environment is named the same as the resource group
# Reader role grants access to view namespaces and pull images
# Writer role grants access to build, push, delete, and restore images
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --service-name container-registry --resource-type namespace --resource ${RESOURCE_GROUP} --region ${REGION} --roles Reader,Writer

# "Granting users access to your cluster through IBM Cloud IAM"
# https://cloud.ibm.com/docs/containers?topic=containers-users#platform
# "User access permissions"
# https://cloud.ibm.com/docs/containers?topic=containers-access_reference
# Kubernetes Service service - 34
# Grant access to use all clusters in the resource group, but not to create or delete clusters
# Editor role grants access to bind services, work with Ingress resources, and set up log forwarding for their apps
# Writer role grants access to the Kubernetes dashboard and Kubernetes resources in namespaces
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --service-name containers-kubernetes --resource-group-name ${RESOURCE_GROUP} --roles Editor,Writer

# "Cloud IAM roles"
# https://cloud.ibm.com/docs/iam?topic=iam-userroles#iamusermanrol
# All service - 22
# Grant access to use all services in the resource group, but not to create or delete services
# Operator role grants access to view service instances and manage aliases, bindings, and credentials
# Manager role grants access to view, create, edit, and complete privileged actions as defined by the service on service-specific resources
ibmcloud iam access-group-policy-create ${ACCESS_GROUP} --resource-group-name ${RESOURCE_GROUP} --roles Operator,Manager


echo "Completed creating polices!"