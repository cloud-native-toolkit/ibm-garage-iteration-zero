module "dev_tools_sonarqube_release" {
  source = "../modules/tools/sonarqube_release"

  ibmcloud_api_key         = "${module.dev_cluster.ibmcloud_api_key}"
  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  cluster_ingress_hostname = "${module.dev_cluster.ingress_hostname}"
  cluster_config_file      = "${module.dev_cluster.config_file_path}"
  postgresql_username      = "${module.dev_infrastructure_postgres.postgresql_service_account_username}"
  postgresql_password      = "${module.dev_infrastructure_postgres.postgresql_service_account_password}"
  postgresql_hostname      = "${module.dev_infrastructure_postgres.postgresql_hostname}"
  postgresql_port          = "${module.dev_infrastructure_postgres.postgresql_port}"
  postgresql_database_name = "${module.dev_infrastructure_postgres.postgresql_database_name}"
  server_url               = "${module.dev_cluster.server_url}"
  cluster_type             = "${var.cluster_type}"
  releases_namespace       = "${module.dev_cluster_namespaces.tools_namespace_name}"
}
