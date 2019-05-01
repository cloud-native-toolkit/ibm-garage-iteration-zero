#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 BM_API_KEY REGION RESOURCE_GROUP CLUSTER_NAME"
   exit 1 # Exit script after printing help
}

# Print helpFunction in case parameters are empty
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

echo "Running Cleanup..."
docker kill ibm-cloud-tools > /dev/null 2>&1
docker rm ibm-cloud-tools > /dev/null 2>&1

echo "Building Image..."
docker build -t ibmcom/ibm-cloud-tools tools/ > /dev/null 2>&1

echo "Initializing..."
# Start IBM Cloud Tools container
docker run -itd --name ibm-cloud-tools -v $(pwd)/kube:/root/kube -v $(pwd)/.kube:/root/.kube -v $(pwd)/.helm:/root/.helm  -e BM_API_KEY=$(echo $1) ibmcom/ibm-cloud-tools /bin/sh -l > /dev/null 2>&1

# Login to IBM Cloud CLI
docker exec -it ibm-cloud-tools ibmcloud login --apikey $(echo $1) -r $(echo $2) -g $(echo $3) > /dev/null 2>&1

# Use IBM Cloud CLI to get kubectl cluster config (placed in /root/.bluemix/plugins/container-service/clusters/{CLUSTER_NAME})
docker exec -it ibm-cloud-tools ibmcloud ks cluster-config --cluster $(echo $4) > /dev/null 2>&1

# Copy Kube Config YML and Kube Server Cert to /root/.kube directory (where kubectl looks for it)
docker exec -it ibm-cloud-tools mkdir -p /root/.kube > /dev/null 2>&1
docker exec -it ibm-cloud-tools find /root/.bluemix/plugins/container-service/clusters -name "*.yml" -exec cp {} /root/.kube/config \; > /dev/null 2>&1
docker exec -it ibm-cloud-tools find /root/.bluemix/plugins/container-service/clusters -name "*.pem" -exec cp {} /root/.kube \; > /dev/null 2>&1
