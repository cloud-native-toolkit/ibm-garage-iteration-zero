module "dev_iks_helm_install" {
  source = "./iks_helm_install"

  resource_group_name     = "${var.resource_group_name}"
  iks_cluster_id          = "${module.dev_iks_cluster.iks_cluster_id}"
  iks_cluster_region      = "${module.dev_iks_cluster.iks_cluster_region}"
  kubeconfig_download_dir = "${var.user_home_dir}"
  ibmcloud_api_key        = "${var.ibmcloud_api_key}"
}
