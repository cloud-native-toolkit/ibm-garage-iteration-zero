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

# IKS Cluster Variables
variable "private_vlan_number" {
  type        = "string"
  description = "Existing private VLAN number for IKS Cluster creation."
}
variable "private_vlan_router_hostname" {
  type        = "string"
  description = "Router hostname for private VLAN defined in private_vlan_number."
}
variable "public_vlan_number" {
  type        = "string"
  description = "Existing public VLAN number for IKS Cluster creation."
}
variable "public_vlan_router_hostname" {
  type        = "string"
  description = "Router hostname for public VLAN defined in public_vlan_number."
}
variable "vlan_datacenter" {
  type        = "string"
  description = "Datacenter for VLANs defined in private_vlan_number and public_vlan_number."
  # default     = "dal10"
}
variable "vlan_region" {
  type        = "string"
  description = "Region for VLANs defined in private_vlan_number and public_vlan_number."
  # default     = "us-south"
}
