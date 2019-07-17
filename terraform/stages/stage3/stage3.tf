module "dev_iks_namespaces" {
  source = "iks_namespaces"

  ibmcloud_api_key        = "${var.ibmcloud_api_key}"
  resource_group_name     = "${module.dev_iks_cluster.resource_group_name}"
  cluster_name            = "${module.dev_iks_cluster.iks_cluster_name}"
  iks_cluster_region      = "${module.dev_iks_cluster.iks_cluster_region}"
  iks_config_file_path    = "${module.dev_iks_cluster.iks_config_file_path}"
}
