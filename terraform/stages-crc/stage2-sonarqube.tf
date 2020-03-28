module "dev_serviceaccount_sonarqube" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/serviceaccount?ref=v2.2.8"

  cluster_type             = var.cluster_type
  namespace                = module.dev_cluster_namespaces.tools_namespace_name
  cluster_config_file_path = module.dev_cluster.config_file_path
  service_account_name     = "sonarqube"
  sscs                     = ["anyuid", "privileged"]
}

module "dev_tools_sonarqube_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/sonarqube_release?ref=v2.3.0"

  cluster_type             = var.cluster_type
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  releases_namespace       = module.dev_cluster_namespaces.tools_namespace_name
  service_account_name     = module.dev_serviceaccount_sonarqube.name
  tls_secret_name          = module.dev_cluster.tls_secret_name
}
