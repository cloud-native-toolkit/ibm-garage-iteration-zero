module "dev_iks_cluster" {
  source = "./iks_cluster"

  resource_group_name           = "${var.resource_group_name}"
  cluster_name                  = "${replace(var.resource_group_name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-cluster"
  private_vlan_number           = "${var.private_vlan_number}"
  private_vlan_router_hostname  = "${var.private_vlan_router_hostname}"
  public_vlan_number            = "${var.public_vlan_number}"
  public_vlan_router_hostname   = "${var.public_vlan_router_hostname}"
  vlan_datacenter               = "${var.vlan_datacenter}"
  vlan_region                   = "${var.vlan_region}"
  kubeconfig_download_dir       = "${var.user_home_dir}"
}
