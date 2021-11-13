provider "ibm" {
  region           = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
}

provider "ibm" {
  alias = "logdna"

  region           = var.logdna_region
  ibmcloud_api_key = var.ibmcloud_api_key
}

provider "ibm" {
  alias = "sysdig"

  region           = var.sysdig_region
  ibmcloud_api_key = var.ibmcloud_api_key
}
