module "dev_infrastructure_logdna" {
  source = "../modules/infrastructure/logdna"

  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  resource_location        = "${module.dev_cluster.region}"
  cluster_id               = "${module.dev_cluster.id}"
  cluster_type             = "${var.cluster_type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  server_url               = "${module.dev_cluster.server_url}"
  ibmcloud_api_key         = "${module.dev_cluster.ibmcloud_api_key}"
  dev_namespace            = "${module.dev_cluster_namespaces.dev_namespace_name}"
  test_namespace           = "${module.dev_cluster_namespaces.test_namespace_name}"
  staging_namespace        = "${module.dev_cluster_namespaces.staging_namespace_name}"
}
