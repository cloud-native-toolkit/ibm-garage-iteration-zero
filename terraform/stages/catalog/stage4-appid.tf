module "dev_infrastructure_appid" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-appid?ref=v1.0.0"

  resource_group_name = module.dev_cluster.resource_group_name
  resource_location   = module.dev_cluster.region
  cluster_id          = module.dev_cluster.id
  namespaces          = []
  namespace_count     = 0
  name_prefix         = var.name_prefix
  tags                = [module.dev_cluster.tag]
}
