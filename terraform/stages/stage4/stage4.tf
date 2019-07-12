module "dev_tools_helm_releases" {
  source = "./tools_helm_releases"

  resource_group_name                           = "${var.resource_group_name}"
  ibmcloud_api_key                              = "${var.ibmcloud_api_key}"
  iks_ingress_hostname                          = "${module.dev_iks_cluster.iks_ingress_hostname}"
  iks_cluster_config_file                       = "${module.dev_iks_cluster.iks_config_file_path}"
  sonarqube_postgresql_service_account_username = "${module.dev_tools_ibmcloud.postgresql_service_account_username}"
  sonarqube_postgresql_service_account_password = "${module.dev_tools_ibmcloud.postgresql_service_account_password}"
  sonarqube_postgresql_hostname                 = "${module.dev_tools_ibmcloud.postgresql_hostname}"
  sonarqube_postgresql_port                     = "${module.dev_tools_ibmcloud.postgresql_port}"
  sonarqube_postgresql_database_name            = "${module.dev_tools_ibmcloud.postgresql_database_name}"
}
