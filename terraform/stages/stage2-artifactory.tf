module "dev_serviceaccount_artifactory" {
  source = "../modules/cluster/serviceaccount"

  cluster_type             = "${var.cluster_type}"
  ibmcloud_api_key         = "${module.dev_cluster.ibmcloud_api_key}"
  server_url               = "${module.dev_cluster.server_url}"
  namespace                = "${module.dev_cluster_namespaces.tools_namespace_name}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  service_account_name     = "artifactory-artifactory"
  sscs                     = ["anyuid", "privileged"]
}

module "dev_tools_artifactory_release" {
  source = "../modules/tools/artifactory_release"

  ibmcloud_api_key         = "${module.dev_cluster.ibmcloud_api_key}"
  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  cluster_ingress_hostname = "${module.dev_cluster.ingress_hostname}"
  cluster_config_file      = "${module.dev_cluster.config_file_path}"
  server_url               = "${module.dev_cluster.server_url}"
  cluster_type             = "${var.cluster_type}"
  releases_namespace       = "${module.dev_cluster_namespaces.tools_namespace_name}"
}
