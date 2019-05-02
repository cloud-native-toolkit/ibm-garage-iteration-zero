#!/bin/bash

SCRIPT_DIR=$(dirname $0)
SRC_DIR="${SCRIPT_DIR}/../src"

helpFunction()
{
   echo ""
   echo "Usage: $0 BM_API_KEY SL_USERNAME  SL_API_KEY"
   exit 1 # Exit script after printing help
}

if [[ -n "$1" ]]; then
   BM_API_KEY="$1"
fi
if [[ -n "$2" ]]; then
   SL_USERNAME="$2"
fi
if [[ -n "$3" ]]; then
   SL_API_KEY="$3"
fi

# Print helpFunction in case parameters are empty
if [[ -z "${BM_API_KEY}" ]] || [[ -z "${SL_USERNAME}" ]] || [[ -z "${SL_API_KEY}" ]]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

DOCKER_IMAGE="garagecatalyst/ibm-kube-terraform:latest"

echo "Running Cleanup..."
docker kill ibm-kube-terraform  > /dev/null 2>&1
docker rm ibm-kube-terraform  > /dev/null 2>&1

echo "Initializing..."
docker run -itd --name ibm-kube-terraform \
   -v $SRC_DIR:/root/tf \
   -v $(pwd)/.kube:/root/.kube \
   -v $(pwd)/.helm:/root/.helm \
   -e BM_API_KEY="${BM_API_KEY}" \
   -e SL_USERNAME="${SL_USERNAME}" \
   -e SL_API_KEY="${SL_API_KEY}" \
   ${DOCKER_IMAGE} \
   /bin/bash  > /dev/null 2>&1
docker exec -it --workdir /root/tf ibm-kube-terraform terraform init > /dev/null 2>&1

echo "Attaching..."
docker attach ibm-kube-terraform
