module "dev_tools_tekton_resources" {
  source = "github.com/cloud-native-toolkit/terraform-tools-tekton-resources.git?ref=v2.3.2"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  resource_namespace       = module.dev_tools_namespace.name
  support_namespace        = module.buildah-unprivileged.namespace
}
