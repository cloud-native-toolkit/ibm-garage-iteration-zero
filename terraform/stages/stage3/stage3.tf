module "dev_iks_namespaces" {
  source = "iks_namespaces"

  resource_group_name     = "${var.resource_group_name}"
  cluster_name            = "${var.cluster_name}"
  iks_cluster_region      = "${module.dev_iks_cluster.iks_cluster_region}"
  iks_config_file_path    = "${module.dev_iks_cluster.iks_config_file_path}"
  ibmcloud_api_key        = "${var.ibmcloud_api_key}"
}
