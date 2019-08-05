variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "resource_location" {
  type        = "string"
  description = "Geographic location of the resource (e.g. us-south, us-east)"
}

variable "cluster_id" {
  type        = "string"
  description = "Id of the cluster"
}

variable "dev_namespace" {
  type        = "string"
  description = "Development namespace"
}

variable "test_namespace" {
  type        = "string"
  description = "Test namespace"
}

variable "staging_namespace" {
  type        = "string"
  description = "Staging namespace"
}

variable "cluster_config_file_path" {
  type        = "string"
  description = "The path to the config file for the cluster"
}

variable "cluster_type" {
  type        = "string"
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "server_url" {
  type        = "string"
  description = "The server url for the cluster"
}

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The api key for IBM Cloud access"
}
