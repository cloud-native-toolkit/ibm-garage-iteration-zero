#!/bin/bash
# --------------------------------------------------------------------------------------------------------
# Name : Account Manager Classic Infrastructure Permissions
#
# Description: Add permissions to a user, the Classic Infrastructure (aka Softlayer) permissions
# needed to create a cluster using the IBM Cloud Kubernetes Service (IKS). Infrastructure
# permissions cannot be added to a group, they have to be added to a user.
#
# --------------------------------------------------------------------------------------------------------
#
# input validation
if [ -z "$1" ]; then
    echo "Usage: acp-mgr-iaas.sh <USER_EMAIL>"
    echo "Grant the user the classic infrastructure permissions needed to create and manage an IKS cluster"
    echo "<USER_EMAIL> - The user's email address (ex: john@ibm.com)"
    exit
fi

USER_EMAIL=$1

# input validation
if [ -z "${USER_EMAIL}" ]; then
    echo "Usage: acp-mgr-iaas.sh <USER_EMAIL>"
    echo "Please provide the user's email address (ex: john@ibm.com)"
    exit
fi

USER_ID=$(ibmcloud sl user list | grep -e "${USER_EMAIL}" | cut -b 1-7)
echo "Softlayer ID for user" ${USER_EMAIL} "is" ${USER_ID}


# To show all Softlayer permissions and whether the user has them:
# ibmcloud sl user permissions ${USER_ID}

# "Classic infrastructure roles" for Kubernetes Service
# https://cloud.ibm.com/docs/containers?topic=containers-access_reference#infra
#
# The Infrastructure permissions checker specifies these 10 required and 14 suggested permissions
#
# Virtual Worker Permissions (aka virtual server permissions):
#    Required: IPMI Remote Management
#    Required: Add Server
#    Required: Cancel Server
#    Required: OS Reloads and Rescue Kernel
#    Required: View Virtual Server Details
#    Suggested: Access All Virtual Servers
#    Suggested: Add Compute with Public Network Port
#
# Physical Worker Permissions (aka physical server permissions):
#    Required: View Hardware Details
#    Required: IPMI Remote Management
#    Required: Add Server
#    Required: Cancel Server
#    Required: OS Reloads and Rescue Kernel
#    Suggested: Access All Hardware
#    Suggested: Add Compute with Public Network Port
#
# Network Permissions:
#    Suggested: Manage DNS
#    Suggested: Edit Hostname/Domain
#    Suggested: Add IP Addresses
#    Suggested: Manage Network Subnet Routes
#    Suggested: Manage Port Control
#    Suggested: Add Compute with Public Network Port
#    Suggested: Manage Certificates (SSL)
#    Suggested: View Certificates (SSL)
#
# Storage Permissions:
#    Suggested: Add/Upgrade Storage (StorageLayer)
#    Suggested: Storage Manage
#

# Create clusters
ibmcloud sl user permission-edit ${USER_ID} --permission REMOTE_MANAGEMENT --enable true       # IPMI Remote Management
ibmcloud sl user permission-edit ${USER_ID} --permission SERVER_ADD --enable true              # Add Server
ibmcloud sl user permission-edit ${USER_ID} --permission PUBLIC_NETWORK_COMPUTE --enable true  # Add Compute with Public Network Port
ibmcloud sl user permission-edit ${USER_ID} --permission SERVER_CANCEL --enable true           # Cancel Server
ibmcloud sl user permission-edit ${USER_ID} --permission SERVER_RELOAD --enable true           # OS Reloads and Rescue Kernel
ibmcloud sl user permission-edit ${USER_ID} --permission VIRTUAL_GUEST_VIEW --enable true      # View Virtual Server Details
ibmcloud sl user permission-edit ${USER_ID} --permission HARDWARE_VIEW --enable true           # View Hardware Details

ibmcloud sl user permission-edit ${USER_ID} --permission TICKET_ADD --enable true              # Add Support Case
ibmcloud sl user permission-edit ${USER_ID} --permission TICKET_EDIT --enable true             # Edit Support Case
ibmcloud sl user permission-edit ${USER_ID} --permission TICKET_VIEW --enable true             # View Support Case

# Other common use cases
ibmcloud sl user permission-edit ${USER_ID} --permission ACCESS_ALL_GUEST --enable true        # Access All Virtual Servers
ibmcloud sl user permission-edit ${USER_ID} --permission ACCESS_ALL_HARDWARE --enable true     # Access All Hardware
ibmcloud sl user permission-edit ${USER_ID} --permission PUBLIC_NETWORK_COMPUTE --enable true  # Add Compute with Public Network Port
ibmcloud sl user permission-edit ${USER_ID} --permission DNS_MANAGE --enable true              # Manage DNS
ibmcloud sl user permission-edit ${USER_ID} --permission HOSTNAME_EDIT --enable true           # Edit Hostname/Domain
ibmcloud sl user permission-edit ${USER_ID} --permission IP_ADD --enable true                  # Add IP Addresses
ibmcloud sl user permission-edit ${USER_ID} --permission NETWORK_ROUTE_MANAGE --enable true    # Manage Network Subnet Routes
ibmcloud sl user permission-edit ${USER_ID} --permission PORT_CONTROL --enable true            # Manage Port Control
ibmcloud sl user permission-edit ${USER_ID} --permission SECURITY_CERTIFICATE_VIEW --enable true     # Manage Certificates (SSL)
ibmcloud sl user permission-edit ${USER_ID} --permission SECURITY_CERTIFICATE_MANAGE --enable true   # View Certificates (SSL)
ibmcloud sl user permission-edit ${USER_ID} --permission ADD_SERVICE_STORAGE --enable true     # Add/Upgrade Storage (StorageLayer)
ibmcloud sl user permission-edit ${USER_ID} --permission NAS_MANAGE --enable true              # Storage Manage


echo "Completed adding permissions!"