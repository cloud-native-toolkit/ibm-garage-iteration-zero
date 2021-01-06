module "dev_tools_tekton_release" {
  source = "github.com/ibm-garage-cloud/terraform-tools-tekton.git?ref=v2.1.0"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  tools_namespace          = module.dev_tools_namespace.name
}

module "dev_tools_tekton_resources" {
  source = "github.com/ibm-garage-cloud/terraform-tools-tekton-resources.git?ref=v2.2.7"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  resource_namespace       = module.dev_tools_namespace.name
}
