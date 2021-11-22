module "dev_tools_ibm_image_registry" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-image-registry.git?ref=v2.1.1"

  resource_group_name = module.dev_cluster.resource_group_name
  region              = module.dev_cluster.region
  cluster_type_code   = module.dev_cluster.type_code
  config_file_path    = module.dev_cluster.config_file_path
  cluster_namespace   = module.dev_tools_namespace.name
  ibmcloud_api_key    = var.ibmcloud_api_key
  registry_password   = var.registry_password
  registry_namespace  = var.registry_namespace
  apply               = var.registry_type == "icr"
}

module "dev_tools_ocp_image_registry" {
  source = "github.com/cloud-native-toolkit/terraform-ocp-image-registry.git?ref=v1.4.0"

  cluster_type_code   = module.dev_cluster.type_code
  config_file_path    = module.dev_cluster.config_file_path
  cluster_namespace   = module.dev_tools_namespace.name
  apply               = var.registry_type == "ocp"
}

module "dev_tools_k8s_image_registry" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-image-registry.git?ref=v1.1.7"

  cluster_type_code   = module.dev_cluster.type_code
  config_file_path    = module.dev_cluster.config_file_path
  cluster_namespace   = module.dev_tools_namespace.name
  apply               = var.registry_type == "other"
  registry_namespace  = var.registry_namespace
  registry_host       = var.registry_host
  registry_user       = var.registry_user
  registry_password   = var.registry_password
  registry_url        = var.registry_url
}
