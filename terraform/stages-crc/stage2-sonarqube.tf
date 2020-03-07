module "dev_infrastructure_postgres" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//self-managed/software/postgres?ref=ocp43-lite"

  resource_group_name = var.resource_group_name
  resource_location   = var.vlan_region
  server_exists       = var.postgres_server_exists
  cluster_id          = module.dev_cluster.id
  namespaces          = concat([module.dev_cluster_namespaces.tools_namespace_name], module.dev_cluster_namespaces.release_namespaces)
  namespace_count     = var.release_namespace_count+1
  postgresql_database = "sonarqube-psql"
  cluster_type        = var.cluster_type
}

module "dev_serviceaccount_sonarqube" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/serviceaccount?ref=ocp43-lite"

  cluster_type             = var.cluster_type
  namespace                = module.dev_cluster_namespaces.tools_namespace_name
  cluster_config_file_path = module.dev_cluster.config_file_path
  service_account_name     = "sonarqube"
  sscs                     = ["anyuid", "privileged"]
}

module "dev_tools_sonarqube_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/sonarqube_release?ref=ocp43-lite"

  cluster_type             = var.cluster_type
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  postgresql_username      = module.dev_infrastructure_postgres.postgresql_service_account_username
  postgresql_password      = module.dev_infrastructure_postgres.postgresql_service_account_password
  postgresql_hostname      = module.dev_infrastructure_postgres.postgresql_hostname
  postgresql_port          = module.dev_infrastructure_postgres.postgresql_port
  postgresql_database_name = module.dev_infrastructure_postgres.postgresql_database_name
  releases_namespace       = module.dev_cluster_namespaces.tools_namespace_name
  service_account_name     = module.dev_serviceaccount_sonarqube.name
  tls_secret_name          = module.dev_cluster.tls_secret_name
  storage_class            = ""
}
