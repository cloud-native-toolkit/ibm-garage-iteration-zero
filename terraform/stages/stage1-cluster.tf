module "dev_cluster" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/cluster/ibmcloud?ref=dev"

  resource_group_name     = "${var.resource_group_name}"
  cluster_name            = "${var.cluster_name}"
  private_vlan_id         = "${var.private_vlan_id}"
  public_vlan_id          = "${var.public_vlan_id}"
  vlan_datacenter         = "${var.vlan_datacenter}"
  cluster_region          = "${var.vlan_region}"
  kubeconfig_download_dir = "${var.user_home_dir}"
  cluster_machine_type    = "${var.cluster_machine_type}"
  cluster_worker_count    = "${var.cluster_worker_count}"
  cluster_hardware        = "${var.cluster_hardware}"
  cluster_type            = "${var.cluster_type}"
  cluster_exists          = "${var.cluster_exists}"
  ibmcloud_api_key        = "${var.ibmcloud_api_key}"
}
