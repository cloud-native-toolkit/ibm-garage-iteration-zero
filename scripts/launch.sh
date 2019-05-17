#!/bin/bash

SCRIPT_DIR=$(dirname $0)
SRC_DIR="$( cd "${SCRIPT_DIR}/../src" ; pwd -P )"

helpFunction()
{
   echo ""
   echo "Iteration Zero Setup"
   echo -e "This script will help setup setup a development environment and tools on the IBM Public Kubernetes Service"
   echo -e "\033[1;31mUsage:\033[0m $0 IBMCLOUD_API_KEY CLASSIC_USERNAME CLASSIC_API_KEY"
   echo -e "  where \033[1;32mIBMCLOUD_API_KEY\033[0m is the IBM Cloud api key"
   echo -e "        \033[1;32mCLASSIC_USERNAME\033[0m is the Classic Infrastructure user name or API user name (e.g. 282165_joe@us.ibm.com)"
   echo -e "        \033[1;32mCLASSIC_API_KEY\033[0m is the Classic Infrastructure api key"
   exit 1 # Exit script after printing help
}

if [[ -n "$1" ]]; then
   IBMCLOUD_API_KEY="$1"
fi
if [[ -n "$2" ]]; then
   CLASSIC_USERNAME="$2"
fi
if [[ -n "$3" ]]; then
   CLASSIC_API_KEY="$3"
fi

# Print helpFunction in case parameters are empty
if [[ -z "${IBMCLOUD_API_KEY}" ]] || [[ -z "${CLASSIC_USERNAME}" ]] || [[ -z "${CLASSIC_API_KEY}" ]]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

DOCKER_IMAGE="garagecatalyst/ibm-garage-cli-tools:latest"

echo "Running Cleanup..."
docker kill ibm-garage-cli-tools
docker rm ibm-garage-cli-tools

echo "Initializing..."
docker run -itd --name ibm-garage-cli-tools \
   -v $SRC_DIR:/home/devops/src \
   -v $(pwd)/.kube:/home/devops/.kube \
   -v $(pwd)/.helm:/home/devops/.helm \
   -e BM_API_KEY="${IBMCLOUD_API_KEY}" \
   -e SL_USERNAME="${CLASSIC_USERNAME}" \
   -e SL_API_KEY="${CLASSIC_API_KEY}" \
   ${DOCKER_IMAGE} \
   /bin/bash  > /dev/null 2>&1
docker exec -it --workdir /home/devops/src/workspace ibm-kube-terraform terraform init > /dev/null 2>&1

echo "Attaching..."
docker attach ibm-garage-cli-tools
