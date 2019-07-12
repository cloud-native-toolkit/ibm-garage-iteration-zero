module "dev_tools_ibmcloud" {
  source = "./tools_ibmcloud"

  resource_group_name = "${var.resource_group_name}"
  resource_location   = "${var.vlan_region}"
}
