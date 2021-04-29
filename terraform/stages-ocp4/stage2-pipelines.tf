module "dev_tools_tekton_release" {
  source = "github.com/cloud-native-toolkit/terraform-tools-tekton.git?ref=v2.1.2"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  tools_namespace          = module.dev_tools_namespace.name
}

module "dev_tools_tekton_resources" {
  source = "github.com/cloud-native-toolkit/terraform-tools-tekton-resources.git?ref=v2.2.17"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  resource_namespace       = module.dev_tools_namespace.name
}
