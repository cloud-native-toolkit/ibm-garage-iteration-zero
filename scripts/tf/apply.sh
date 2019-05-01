#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 BM_API_KEY SL_USERNAME  SL_API_KEY"
   exit 1 # Exit script after printing help
}

# Print helpFunction in case parameters are empty
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

echo "Running Cleanup..."
docker kill ibm-kube-terraform  > /dev/null 2>&1
docker rm ibm-kube-terraform  > /dev/null 2>&1

echo "Building Image..."
docker build -t ibm-kube-terraform -f tools/Dockerfile tools/

echo "Initializing..."
docker run -itd --name ibm-kube-terraform -v $(pwd)/tf:/root/tf -v $(pwd)/.kube:/root/.kube -v $(pwd)/.helm:/root/.helm -e BM_API_KEY=$(echo $1) -e SL_USERNAME=$(echo $2) -e SL_API_KEY=$(echo $3) ibm-kube-terraform /bin/bash  > /dev/null 2>&1
docker exec -it --workdir /root/tf ibm-kube-terraform terraform init > /dev/null 2>&1

echo "Applying..."
docker exec -it --workdir /root/tf ibm-kube-terraform terraform apply
