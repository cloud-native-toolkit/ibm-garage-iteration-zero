module "dev_tools_sourcecontrol" {
  source = "github.com/ibm-garage-cloud/terraform-k8s-source-control.git?ref=v1.2.2"

  config_file_path  = module.dev_cluster.config_file_path
  cluster_type_code = module.dev_cluster.type_code
  cluster_namespace = module.dev_tools_namespace.name
  type              = var.source_control_type
  url               = var.source_control_url
}
