module "dev_tools_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-namespace.git?ref=v3.1.2"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  name                     = var.tools_namespace
}

module "dev_sre_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-namespace.git?ref=v3.1.2"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  name                     = var.sre_namespace
}
