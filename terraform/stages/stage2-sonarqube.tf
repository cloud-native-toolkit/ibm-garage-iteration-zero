module "dev_tools_sonarqube" {
  source = "github.com/ibm-garage-cloud/terraform-tools-sonarqube.git?ref=v1.9.2"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  tls_secret_name          = module.dev_cluster.tls_secret_name
  releases_namespace       = module.dev_tools_namespace.name
  service_account_name     = "sonarqube"
  postgresql               = {
    external      = false
    username      = ""
    password      = ""
    hostname      = ""
    port          = ""
    database_name = ""
  }
}
