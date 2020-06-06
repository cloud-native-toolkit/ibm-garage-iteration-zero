module "dev_infrastructure_sysdig" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-sysdig.git?ref=398-remove-dependencies"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_type             = var.cluster_type
  name_prefix              = var.name_prefix
  namespace                = module.dev_sre_namespace.name
  tags                     = [module.dev_cluster.tag]
  exists                   = var.sysdig_exists == "true"
  name                     = var.sysdig_name
}
