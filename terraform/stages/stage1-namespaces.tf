module "dev_tools_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-namespace.git?ref=v3.1.3"

  cluster_config_file_path = module.dev_cluster.config_file_path
  name                     = var.tools_namespace
}

module "dev_sre_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-namespace.git?ref=v3.1.3"

  cluster_config_file_path = module.dev_cluster.config_file_path
  name                     = var.sre_namespace
}
