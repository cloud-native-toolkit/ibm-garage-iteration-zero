module "dev_infrastructure_appid" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/appid?ref=v2.2.0"

  resource_group_name = module.dev_cluster.resource_group_name
  resource_location   = module.dev_cluster.region
  cluster_id          = module.dev_cluster.id
  namespaces          = concat([module.dev_cluster_namespaces.tools_namespace_name], module.dev_cluster_namespaces.other_namespaces)
  namespace_count     = var.other_namespace_count+1
  name_prefix         = var.name_prefix
  tags                = [module.dev_cluster.tag]
}
