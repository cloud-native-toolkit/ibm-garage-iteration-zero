#!/bin/bash

# IBM Cloud Garage, Catalyst Team

SCRIPT_DIR=$(dirname $0)
SRC_DIR="$( cd "${SCRIPT_DIR}/terraform" ; pwd -P )"


helpFunction()
{
    RED='\033[0;31m'
    CYAN='\033[0;36m'
    LIGHT_GRAY='\033[0;37m'
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color

    error="$1"

    echo "Iteration Zero Setup"
    echo -e "This script will help setup setup a development environment and tools on the IBM Public Kubernetes Service"
    echo ""
    echo -e "${CYAN}Usage:${NC} $0"
    echo ""
    if [[ "${error}" =~ "file is not found" ]]; then
        echo -e "${RED}${error}${NC}"
        echo -e "Credentials should be provided in a file named ${CYAN}'${ENV}.properties'${NC}"
    else
        echo -e "${RED}${error}${NC}"
        echo -e "The ${ENV}.properties file should contain the following values:"
        echo -e "   ${GREEN}ibmcloud.api.key${NC} is the IBM Cloud api key"
        echo -e "   ${GREEN}classic.username${NC} is the Classic Infrastructure user name or API user name (e.g. 282165_joe@us.ibm.com)"
        echo -e "   ${GREEN}classic.api.key${NC} is the Classic Infrastructure api key"
    fi

   echo ""
   exit 1 # Exit script after printing help
}

ENV="credentials"

function prop {
    grep "${1}" ${ENV}.properties|cut -d'=' -f2
}

if [[ -f "${ENV}.properties" ]]; then
    # Load the credentials
    IBMCLOUD_API_KEY=$(prop 'ibmcloud.api.key')
    CLASSIC_API_KEY=$(prop 'classic.api.key')
    CLASSIC_USERNAME=$(prop 'classic.username')
else
    helpFunction "The ${ENV}.properties file is not found."
fi

# Print helpFunction in case parameters are empty
if [[ -z "${IBMCLOUD_API_KEY}" ]] || [[ -z "${CLASSIC_USERNAME}" ]] || [[ -z "${CLASSIC_API_KEY}" ]]
then
    helpFunction "Some of the credentials values are empty. "
fi

DOCKER_IMAGE="garagecatalyst/ibm-garage-cli-tools:latest"
CONTAINER_NAME="ibm-garage-cli-tools"

echo "Running Cleanup..."
docker kill ${CONTAINER_NAME}
docker rm ${CONTAINER_NAME}

echo "Initializing..."
docker run -itd --name ${CONTAINER_NAME} \
   -v ${SRC_DIR}:/home/devops/src \
   -v $(pwd)/.kube:/home/devops/.kube \
   -v $(pwd)/.helm:/home/devops/.helm \
   -e TF_VAR_ibmcloud_api_key="${IBMCLOUD_API_KEY}" \
   -e BM_API_KEY="${IBMCLOUD_API_KEY}" \
   -e SL_USERNAME="${CLASSIC_USERNAME}" \
   -e SL_API_KEY="${CLASSIC_API_KEY}" \
   ${DOCKER_IMAGE}
docker exec -it --workdir /home/devops/src/workspace ${CONTAINER_NAME} terraform init

echo "Attaching..."
docker attach ${CONTAINER_NAME}
