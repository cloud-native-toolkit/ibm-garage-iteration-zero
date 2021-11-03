module "logdna" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-logdna.git?ref=v4.0.0"

  cluster_name             = module.dev_cluster.name
  cluster_id               = module.dev_cluster.id
  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = var.logdna_region != "" ? var.logdna_region : module.dev_cluster.region
  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  namespace                = module.dev_sre_namespace.name
  tools_namespace          = module.dev_tools_namespace.name
  name_prefix              = var.name_prefix
  provision                = var.provision_logdna == "true"
  name                     = var.logdna_name
}
