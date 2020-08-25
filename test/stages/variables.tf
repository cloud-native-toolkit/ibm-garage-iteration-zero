# Terraform Variables
variable "user_home_dir" {
  type        = string
  description = "Home directory of run user. This is where Kube config will be downloaded."
  default     = "/home/devops"
}

# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "registry_namespace" {
  type        = string
  description = "The namespace that should be used in the IBM Container Registry. If not provided the value will default to the resource group name."
  default     = ""
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
variable "cluster_machine_type" {
  type        = string
  description = "The machine type for the cluster worker nodes (b3c.4x16 is minimum for OpenShift)"
  default     = "b3c.4x16"
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

variable "tools_namespace" {
  type        = string
  description = "Namespace for tools"
  default     = "tools"
}

variable "sre_namespace" {
  type        = string
  description = "Namespace for SRE tools"
  default     = "ibm-observe"
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

variable "postgres_server_exists" {
  type        = string
  description = "Flag indicating if the postgres server already exists (true or false)"
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

variable "provision_logdna" {
  type        = string
  description = "Flag indicating that a logdna instance should be provisioned"
  default     = "false"
}

variable "logdna_name" {
  type        = string
  description = "The name of the logdna instance. This is particularly used for an existing logdna instance. If not provided the name will be derived from the name_prefix/resource_group"
  default     = ""
}

variable "logdna_region" {
  type        = string
  description = "The region where the logdna instance will be/has been provisioned. If not provided this will default to the overall region"
  default     = ""
}

variable "provision_sysdig" {
  type        = string
  description = "Flag indicating that a sysdig instance should be provisioned"
  default     = "false"
}

variable "sysdig_name" {
  type        = string
  description = "The name of the sysdig instance. This is particularly used for an existing sysdig instance. If not provided the name will be derived from the name_prefix/resource_group"
  default     = ""
}

variable "sysdig_region" {
  type        = string
  description = "The region where the sysdig instance will be/has been provisioned. If not provided this will default to the overall region"
  default     = ""
}

variable "vpc_zone_names" {
  type        = string
  description = "Comma-separated list of vpc zone names"
  default     = ""
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

variable "provision_activity_tracker" {
  type = string
  description = "Flag indicating that the activity_tracker instance should be provisioned"
  default = "false"
}
