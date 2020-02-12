module "dev_infrastructure_sysdig" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/sysdig?ref=v2.1.8"

  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  resource_location        = "${module.dev_cluster.region}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  dev_namespace            = "${module.dev_cluster_namespaces.tools_namespace_name}"
  test_namespace           = "${module.dev_cluster_namespaces.tools_namespace_name}"
  staging_namespace        = "${module.dev_cluster_namespaces.tools_namespace_name}"
  cluster_type             = "${var.cluster_type}"
  name_prefix              = "${var.name_prefix}"
}
