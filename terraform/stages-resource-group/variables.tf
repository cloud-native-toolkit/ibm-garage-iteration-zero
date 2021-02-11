# Resource Group Variables
variable "resource_group_names" {
  type        = string
  description = "Comma-separated list of resource group names that should be created."
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The api key for IBM Cloud access"
}

variable "TF_VERSION" {
  type = string
  description = "The version of terraform that should be used"
  default = "0.12"
}
