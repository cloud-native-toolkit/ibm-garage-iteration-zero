module "dev_cluster_namespaces" {
  source = "github.com/ibm-garage-cloud/terraform-cluster-namespace.git?ref=v1.0.0"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  tools_namespace          = var.tools_namespace
  release_namespaces       = var.release_namespaces
}

module "dev_sre_namespace" {
  source = "github.com/ibm-garage-cloud/terraform-cluster-namespace.git?ref=v2.0.0"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  name                     = var.sre_namespace
}
