module "buildah-unprivileged" {
  source = "github.com/cloud-native-toolkit/terraform-ocp-buildah-unprivileged.git?ref=v1.0.0"

  cluster_config_file = module.dev_cluster.config_file_path
  namespace = module.toolkit_namespace.name
}
