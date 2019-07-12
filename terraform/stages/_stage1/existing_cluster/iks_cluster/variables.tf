# Resource Group Variables
variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

# Cluster Variables
variable "cluster_name" {
  type        = "string"
  description = "The name of the cluster that will be created within the resource group"
}

variable "iks_cluster_region" {
  type        = "string"
  description = "Region of existing IKS cluster to which Helm will be installed on."
}

variable "kubeconfig_download_dir" {
  type        = "string"
  description = "Directory to download kubeconfig."
}
