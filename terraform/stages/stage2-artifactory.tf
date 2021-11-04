module "dev_tools_artifactory" {
  source = "github.com/cloud-native-toolkit/terraform-tools-artifactory.git?ref=v1.10.3"

  cluster_type             = module.dev_cluster.type_code
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  releases_namespace       = module.dev_tools_namespace.name
  service_account          = "artifactory-artifactory"
  storage_class            = var.storage_class
}
