module "dev_infrastructure_appid" {
  source = "github.com/cloud-native-toolkit/garage-terraform-modules.git//cloud-managed/services/appid?ref=v2.3.3"

  resource_group_name = module.dev_cluster.resource_group_name
  resource_location   = module.dev_cluster.region
  cluster_id          = module.dev_cluster.id
  namespaces          = [module.dev_tools_namespace.name]
  namespace_count     = 1
  name_prefix         = var.name_prefix
  tags                = [module.dev_cluster.tag]
}
