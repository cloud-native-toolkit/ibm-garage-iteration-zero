module "dev_tools_sonarqube" {
  source = "github.com/ibm-garage-cloud/terraform-tools-sonarqube.git?ref=v1.5.1"

  cluster_type             = module.dev_cluster.type_code
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
