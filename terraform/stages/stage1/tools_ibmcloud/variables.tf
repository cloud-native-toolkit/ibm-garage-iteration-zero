variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "resource_location" {
  type        = "string"
  description = "Location for resources to be provisioned (e.g. \"us-south\")."
  default     = "us-south"
}
