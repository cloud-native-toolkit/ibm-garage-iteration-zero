# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The api key for IBM Cloud access"
}

# Cluster Variables
variable "private_vlan_id" {
  type        = string
  description = "Existing private VLAN id for cluster creation."
  default     = ""
}

variable "public_vlan_id" {
  type        = string
  description = "Existing public VLAN number for cluster creation."
  default     = ""
}

variable "vlan_datacenter" {
  type        = string
  description = "Datacenter for VLANs defined in private_vlan_number and public_vlan_number."
  default     = ""
}

variable "region" {
  type        = string
  description = "Region for VLANs defined in private_vlan_number and public_vlan_number."
  default     = ""
}

variable "vlan_region" {
  type        = string
  description = "(Deprecated) Region for VLANs defined in private_vlan_number and public_vlan_number."
  default     = ""
}

# Cluster Variables
variable "flavor" {
  type        = string
  description = "The machine type for the cluster worker nodes (b3c.4x16 is minimum for OpenShift)"
  default     = "mx2.4x32"
}

# Cluster Variables_num
variable "cluster_worker_count" {
  description = "The number of worker nodes for the cluster"
  default     = 3
}

# Cluster Variables
variable "cluster_hardware" {
  type        = string
  description = "The type of hardware for the cluster"
  default     = "shared"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = ""
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "cluster_exists" {
  type        = string
  description = "Flag indicating if the cluster already exists (true or false)"
  default     = "false"
}

variable "name_prefix" {
  type        = string
  description = "Prefix name that should be used for the cluster and services. If not provided then resource_group_name will be used"
  default     = ""
}

variable "TF_VERSION" {
  type = string
  description = "The version of terraform that should be used"
  default = "0.12"
}

variable "vpc_cluster" {
  type        = string
  description = "Flag indicating if the cluster is vpc"
  default     = "false"
}

variable "vpc_zone_count" {
  type        = string
  description = "The number of vpc zones (0-3)"
  default     = "0"
}

variable "cluster_provision_cos" {
  type = string
  description = "Flag indicating that cos instance should be provisioned by cluster-platform module"
  default = "true"
}

variable "cos_name" {
  type        = string
  description = "The name of the existing cos instance"
  default     = ""
}
