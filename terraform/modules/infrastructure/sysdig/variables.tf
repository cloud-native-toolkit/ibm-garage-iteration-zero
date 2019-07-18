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

variable "staging_namespace" {
  type        = "string"
  description = "Staging namespace"
}
