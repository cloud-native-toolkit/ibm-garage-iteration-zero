variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "cluster_name" {
  type        = "string"
  description = "The name of the cluster."
}

variable "iks_cluster_region" {
  type        = "string"
  description = "Region of existing IKS cluster to which Helm will be installed on."
}

variable "iks_config_file_path" {
  type        = "string"
  description = "The path to the config file for the cluster"
}

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The api key for IBM Cloud access"
}
