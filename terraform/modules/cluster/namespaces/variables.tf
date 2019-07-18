variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "cluster_name" {
  type        = "string"
  description = "The name of the cluster."
}

variable "cluster_region" {
  type        = "string"
  description = "Region of existing IKS cluster to which Helm will be installed on."
}

variable "cluster_config_file_path" {
  type        = "string"
  description = "The path to the config file for the cluster"
}

variable "server_url" {
  type        = "string"
  description = "The server url for the cluster"
}

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The api key for IBM Cloud access"
}

variable "tools_namespace" {
  type        = "string"
  description = "The tools namespace"
}

variable "dev_namespace" {
  type        = "string"
  description = "The dev namespace"
}

variable "test_namespace" {
  type        = "string"
  description = "The test namespace"
}

variable "staging_namespace" {
  type        = "string"
  description = "The staging namespace"
}

variable "cluster_type" {
  type        = "string"
  description = "The type of cluster that should be created (openshift or kubernetes)"
}
