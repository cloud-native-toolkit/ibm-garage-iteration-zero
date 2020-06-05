module "dev_tools_tekton_release" {
  source = "github.com/ibm-garage-cloud/terraform-tools-tekton.git?ref=v1.2.0"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  tools_namespace          = module.dev_cluster_namespaces.tools_namespace_name
}

module "dev_tools_tekton_resources" {
  source = "github.com/ibm-garage-cloud/terraform-tools-tekton-resources.git?ref=v1.1.0"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  tekton_namespace         = module.dev_tools_tekton_release.namespace
  resource_namespace       = module.dev_cluster_namespaces.tools_namespace_name
}
