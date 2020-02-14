module "dev_tools_catalystdashboard_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/catalystdashboard_release?ref=ocp43"

  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_type             = var.cluster_type
  cluster_version          = module.dev_cluster.cluster_version
  releases_namespace       = module.dev_cluster_namespaces.tools_namespace_name
  tls_secret_name          = module.dev_cluster.tls_secret_name
}
