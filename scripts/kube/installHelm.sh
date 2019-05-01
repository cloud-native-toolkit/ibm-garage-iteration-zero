# Installation script per IBM Cloud Documentation
# https://console.bluemix.net/docs/containers/cs_integrations.html#helm

# Install Helm into the cluster (kube-system namespace)
docker exec -it ibm-cloud-tools kubectl apply -f https://raw.githubusercontent.com/IBM-Cloud/kube-samples/master/rbac/serviceaccount-tiller.yaml
docker exec -it ibm-cloud-tools helm init --service-account tiller

# Setup IBM Cloud Repositories
docker exec -it ibm-cloud-tools helm repo add ibm https://registry.bluemix.net/helm/ibm
docker exec -it ibm-cloud-tools helm repo add ibm-charts https://registry.bluemix.net/helm/ibm-charts

# Setup Helm Incubator Repository
docker exec -it ibm-cloud-tools helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

# Refresh Repository Cache
docker exec -it ibm-cloud-tools helm repo update
