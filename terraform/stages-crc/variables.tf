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

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The api key for IBM Cloud access"
}

# Cluster Variables
variable "private_vlan_id" {
  type        = "string"
  description = "Existing private VLAN id for cluster creation."
  default     = ""
}

variable "public_vlan_id" {
  type        = "string"
  description = "Existing public VLAN number for cluster creation."
  default     = ""
}

variable "vlan_datacenter" {
  type        = "string"
  description = "Datacenter for VLANs defined in private_vlan_number and public_vlan_number."
  default     = ""
}

variable "vlan_region" {
  type        = "string"
  description = "Region for VLANs defined in private_vlan_number and public_vlan_number."
}

# Cluster Variables
variable "cluster_machine_type" {
  type        = "string"
  description = "The machine type for the cluster worker nodes (b3c.4x16 is minimum for OpenShift)"
  default     = "b3c.4x16"
}

# Cluster Variables_num
variable "cluster_worker_count" {
  description = "The number of worker nodes for the cluster"
  default     = 3
}

# Cluster Variables
variable "cluster_hardware" {
  type        = "string"
  description = "The type of hardware for the cluster"
  default     = "shared"
}

variable "tools_namespace" {
  type        = "string"
  description = "Namespace for tools"
  default     = "tools"
}

variable "dev_namespace" {
  type        = "string"
  description = "Namespace for dev"
  default     = "dev"
}

variable "test_namespace" {
  type        = "string"
  description = "Namespace for test"
  default     = "test"
}

variable "staging_namespace" {
  type        = "string"
  description = "Namespace for staging"
  default     = "staging"
}

variable "cluster_name" {
  type        = "string"
  description = "The name of the cluster"
  default     = ""
}

variable "cluster_type" {
  type        = "string"
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "cluster_exists" {
  type        = "string"
  description = "Flag indicating if the cluster already exists (true or false)"
  default     = "false"
}

variable "postgres_server_exists" {
  type        = "string"
  description = "Flag indicating if the postgres server already exists (true or false)"
  default     = "false"
}

variable "name_prefix" {
  type        = "string"
  description = "Prefix name that should be used for the cluster and services. If not provided then resource_group_name will be used"
  default     = ""
}
