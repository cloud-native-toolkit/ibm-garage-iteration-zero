module "dev_tools_argocd_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/argocd_release?ref=v2.2.9"

  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_type             = var.cluster_type
  releases_namespace       = module.dev_cluster_namespaces.tools_namespace_name
  tls_secret_name          = module.dev_cluster.tls_secret_name
}
