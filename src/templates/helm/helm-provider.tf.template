provider "helm" {
  service_account = "tiller"
}

data "helm_repository" "ibm" {
    name = "ibm"
    url  = "https://registry.bluemix.net/helm/ibm"
}

data "helm_repository" "ibm_charts" {
    name = "ibm_charts"
    url  = "https://registry.bluemix.net/helm/ibm-charts"
}

data "helm_repository" "incubator" {
    name = "incubator"
    url  = "https://kubernetes-charts-incubator.storage.googleapis.com/"
}
