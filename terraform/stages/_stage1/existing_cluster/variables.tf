# Terraform Variables
variable "user_home_dir" {
  type        = "string"
  description = "Home directory of run user. This is where Kube config will be downloaded."
  default     = "/home/devops"
}

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

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The api key for IBM Cloud access"
}

variable "vlan_region" {
  type        = "string"
  description = "Region for VLANs defined in private_vlan_number and public_vlan_number."
  # default     = "us-south"
}
