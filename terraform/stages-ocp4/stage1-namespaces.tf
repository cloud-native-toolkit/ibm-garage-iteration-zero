module "dev_cluster_namespaces" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/namespaces?ref=v2.3.3"

  cluster_type             = module.dev_cluster.type
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  tools_namespace          = var.tools_namespace
  release_namespaces       = var.release_namespaces
}

module "dev_sre_namespace" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/namespaces?ref=v2.3.3"

  cluster_type             = module.dev_cluster.type
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  tools_namespace          = var.sre_namespace
  release_namespaces       = []
}
