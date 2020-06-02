module "dev_tools_sonarqube" {
  source = "github.com/ibm-garage-cloud/terraform-tools-sonarqube.git?ref=v1.3.0"

  cluster_type             = var.cluster_type
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  releases_namespace       = module.dev_cluster_namespaces.tools_namespace_name
  service_account_name     = "sonarqube"
  tls_secret_name          = module.dev_cluster.tls_secret_name
  postgresql               = {
    external      = false
    username      = ""
    password      = ""
    hostname      = ""
    port          = ""
    database_name = ""
  }
}

module "dev_serviceaccount_sonarqube" {
  source = "github.com/ibm-garage-cloud/terraform-cluster-serviceaccount.git?ref=v1.3.0"

  cluster_type             = var.cluster_type
  cluster_config_file_path = module.dev_cluster.config_file_path
  namespace                = module.dev_tools_sonarqube.namespace
  service_account_name     = module.dev_tools_sonarqube.service_account
  sscs                     = ["anyuid", "privileged"]
}
