module "dev_cluster_namespaces" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/namespaces?ref=ocp43"

  cluster_type             = module.dev_cluster.type
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  tools_namespace          = var.tools_namespace
  other_namespaces         = var.other_namespaces
}
