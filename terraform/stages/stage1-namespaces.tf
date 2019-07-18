module "dev_cluster_namespaces" {
  source = "../modules/cluster/namespaces"

  ibmcloud_api_key         = "${module.dev_cluster.ibmcloud_api_key}"
  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  cluster_name             = "${module.dev_cluster.name}"
  cluster_type             = "${var.cluster_type}"
  cluster_region           = "${module.dev_cluster.region}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  server_url               = "${module.dev_cluster.server_url}"
  tools_namespace          = "${var.tools_namespace}"
  dev_namespace            = "${var.dev_namespace}"
  test_namespace           = "${var.test_namespace}"
  staging_namespace        = "${var.staging_namespace}"
}
