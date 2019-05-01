data "ibm_resource_group" "iks_resource_group" {
  name = "${var.resource_group_name}"
}

data "ibm_network_vlan" "iks_private_vlan" {
    number = "${var.private_vlan_number}"
    router_hostname ="${var.private_vlan_router_hostname}"
}

data "ibm_network_vlan" "iks_public_vlan" {
  number = "${var.public_vlan_number}"
  router_hostname ="${var.public_vlan_router_hostname}"
}

resource "ibm_container_cluster" "iks_cluster" {
  name              = "${data.ibm_resource_group.iks_resource_group.name}-cluster"
  datacenter        = "${var.vlan_datacenter}"
  machine_type      = "u3c.2x4"
  hardware          = "shared"
  region            = "${var.vlan_region}"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
  worker_num        = 2
  private_vlan_id   = "${data.ibm_network_vlan.iks_private_vlan.id}"
  public_vlan_id    = "${data.ibm_network_vlan.iks_public_vlan.id}"
}
