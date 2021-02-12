# Resource Group Variables
variable "users" {
  type        = string
  description = "Comma-separated list of users to invite to the IBM Cloud account"
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
