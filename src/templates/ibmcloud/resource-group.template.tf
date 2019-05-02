variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "quota_id" {
  description = "The quota ID for the resource group"
}

resource "ibm_resource_group" "iks_resource_group" {
  name = "${var.resource_group_name}"
  quota_id = "${var.quota_id}"
}
