# Resource Group Variables
variable "resource_group_name" {
  type        = "string"
  description = "The name of the IBM Cloud resource group where the cluster will be created/can be found."
}

# Cluster Variables
variable "cluster_name" {
  type        = "string"
  description = "The name of the cluster that will be created within the resource group"
}

# Cluster Variables
variable "cluster_machine_type" {
  type        = "string"
  description = "The machine type for the cluster worker nodes. The list of available machine types can be found using `ibmcloud ks machine-types <data-center>`"
  default     = "b3c.4x16"
}

# Cluster Variables
variable "cluster_worker_count" {
  type        = "string"
  description = "The number of worker nodes for the cluster"
  default     = "2"
}

# Cluster Variables
variable "cluster_hardware" {
  type        = "string"
  description = "The type of hardware for the cluster (shared, dedicated)"
  default     = "shared"
}

# Cluster Variables
variable "private_vlan_id" {
  type        = "string"
  description = "Existing private VLAN id for cluster creation."
}

variable "public_vlan_id" {
  type        = "string"
  description = "Existing public VLAN number for cluster creation."
}

variable "vlan_datacenter" {
  type        = "string"
  description = "Datacenter for VLANs defined in private_vlan_number and public_vlan_number."
}

variable "cluster_region" {
  type        = "string"
  description = "The IBM Cloud region where the cluster will be/has been installed."
}

variable "kubeconfig_download_dir" {
  type        = "string"
  description = "Directory where kubeconfig will be downloaded."
}

variable "cluster_type" {
  type        = "string"
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The IBM Cloud api token"
}

variable "cluster_exists" {
  type        = "string"
  description = "Flag indicating if the cluster already exists (true or false)"
}

variable "login_user" {
  type        = "string"
  description = "The username to log in to openshift"
  default     = "apikey"
}
