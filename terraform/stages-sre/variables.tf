# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The api key for IBM Cloud access"
}

variable "region" {
  type        = string
  description = "Region for VLANs defined in private_vlan_number and public_vlan_number."
  default     = ""
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

variable "provision_logdna" {
  type        = string
  description = "Flag indicating that a logdna instance should be provisioned"
  default     = "true"
}

variable "logdna_name" {
  type        = string
  description = "The name of the logdna instance. This is particularly used for an existing logdna instance. If not provided the name will be derived from the name_prefix/resource_group"
  default     = ""
}

variable "provision_sysdig" {
  type        = string
  description = "Flag indicating that a sysdig instance should be provisioned"
  default     = "true"
}

variable "sysdig_name" {
  type        = string
  description = "The name of the sysdig instance. This is particularly used for an existing sysdig instance. If not provided the name will be derived from the name_prefix/resource_group"
  default     = ""
}

variable "provision_object_storage" {
  type = string
  description = "Flag indicating that cos instance should be provisioned by cluster-platform module"
  default = "true"
}

variable "object_storage_name" {
  type        = string
  description = "The name of the existing cos instance"
  default     = ""
}

variable "provision_key_protect" {
  type        = string
  description = "Flag indicating that the key-protect instance should be provisioned"
  default     = "true"
}

variable "provision_activity_tracker" {
  type        = string
  description = "Flag indicating that the key-protect instance should be provisioned"
  default     = "false"
}
