variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "cluster_config_file" {
  type        = "string"
  description = "Cluster config file for Kubernetes cluster."
}

variable "releases_namespace" {
  type        = "string"
  description = "Name of the existing namespace where the Helm Releases will be deployed."
}

variable "cluster_ingress_hostname" {
  type        = "string"
  description = "Ingress hostname of the IKS cluster."
}

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The api key for IBM Cloud access"
}

variable "server_url" {
  type        = "string"
  description = "The master url of the server"
}

variable "cluster_name" {
  type        = "string"
  description = "The name of the cluster"
}

variable "cluster_type" {
  description = "The cluster type (openshift or kubernetes)"
}
