module "dev_infrastructure_sysdig" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig.git?ref=v2.3.3"

  cluster_name             = module.dev_cluster.name
  cluster_id               = module.dev_cluster.id
  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = var.sysdig_region != "" ? var.sysdig_region : module.dev_cluster.region
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_type             = module.dev_cluster.type_code
  name_prefix              = var.name_prefix
  namespace                = module.dev_sre_namespace.name
  tools_namespace          = module.dev_tools_namespace.name
  tags                     = [module.dev_cluster.tag]
  provision                = var.provision_sysdig == "true"
  name                     = var.sysdig_name
  sync                     = module.dev_infrastructure_logdna.sync
}
