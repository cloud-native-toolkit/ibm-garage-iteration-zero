variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "resource_location" {
  type        = "string"
  description = "Location for resources to be provisioned (e.g. \"us-south\")."
  default     = "us-south"
}

variable "iks_cluster_id" {
  type        = "string"
  description = "ID of the IKS Cluster."
}

variable "prod_namespace" {
  type        = "string"
  description = "Name of the prod namespace for the IKS Cluster."
}

variable "dev_namespace" {
  type        = "string"
  description = "Name of the dev namespace for the IKS Cluster."
}
