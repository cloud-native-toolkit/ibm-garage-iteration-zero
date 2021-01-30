module "dev_tools_ibm_image_registry" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-image-registry.git?ref=v1.3.6"

  resource_group_name = module.dev_cluster.resource_group_name
  cluster_region      = module.dev_cluster.region
  cluster_type_code   = module.dev_cluster.type_code
  config_file_path    = module.dev_cluster.config_file_path
  cluster_namespace   = module.dev_tools_namespace.name
  ibmcloud_api_key    = var.registry_password
  registry_namespace  = var.registry_namespace
  apply               = var.registry_type == "icr"
}

module "dev_tools_ocp_image_registry" {
  source = "github.com/ibm-garage-cloud/terraform-ocp-image-registry.git?ref=v1.3.4"

  cluster_type_code   = module.dev_cluster.type_code
  config_file_path    = module.dev_cluster.config_file_path
  cluster_namespace   = module.dev_tools_namespace.name
  apply               = var.registry_type == "ocp"
}

module "dev_tools_k8s_image_registry" {
  source = "github.com/ibm-garage-cloud/terraform-k8s-image-registry.git?ref=v1.1.5"

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
