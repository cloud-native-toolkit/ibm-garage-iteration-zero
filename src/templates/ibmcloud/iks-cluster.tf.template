data "ibm_resource_group" "test_resource_group" {
  name = "test"
}

data "ibm_network_vlan" "iks_private_vlan" {
    number = 2372
    router_hostname = "bcr01a.dal10"
}

data "ibm_network_vlan" "iks_public_vlan" {
    number = 1849
    router_hostname = "fcr01a.dal10"
}

resource "ibm_container_cluster" "iks_cluster" {
  name              = "${data.ibm_resource_group.iks_resource_group.name}-cluster"
  datacenter        = "dal10"
  machine_type      = "u3c.2x4"
  hardware          = "shared"
  region            = "us-south"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
  worker_num        = 2
  private_vlan_id   = "${data.ibm_network_vlan.iks_private_vlan.id}"
  public_vlan_id    = "${data.ibm_network_vlan.iks_public_vlan.id}"
}
