module "dev_infrastructure_sysdig" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/sysdig?ref=v2.4.3"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_type             = var.cluster_type
  name_prefix              = var.name_prefix
  namespace                = module.dev_sre_namespace.tools_namespace_name
  tags                     = [module.dev_cluster.tag]
}
