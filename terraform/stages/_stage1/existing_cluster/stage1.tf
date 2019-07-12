module "dev_iks_cluster" {
  source = "./iks_cluster"

  resource_group_name           = "${var.resource_group_name}"
  cluster_name                  = "${var.cluster_name}"
  iks_cluster_region            = "${var.vlan_region}"
  kubeconfig_download_dir       = "${var.user_home_dir}"
}
