module "dev_tools_tekton_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/tekton_release?ref=v2.2.5"

  cluster_type             = module.dev_cluster.type
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  tools_namespace          = module.dev_cluster_namespaces.tools_namespace_name
}

module "dev_tools_tekton_resources" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/tekton_resources?ref=v2.2.17"

  cluster_config_file_path = module.dev_cluster.config_file_path
  tekton_namespace         = module.dev_tools_tekton_release.namespace
  resource_namespace       = module.dev_cluster_namespaces.tools_namespace_name
}
