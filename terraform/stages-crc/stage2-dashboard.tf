module "dev_tools_dashboard_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/developerdashboard_release?ref=v2.4.4"

  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_type             = var.cluster_type
  releases_namespace       = module.dev_cluster_namespaces.tools_namespace_name
  tls_secret_name          = module.dev_cluster.tls_secret_name
  image_tag                = "1.0.31"
}
