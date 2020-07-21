module "dev_infrastructure_cos" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-object-storage?ref=v1.0.0"

  resource_group_name = module.dev_cluster.resource_group_name
  resource_location   = module.dev_cluster.region
  cluster_id          = module.dev_cluster.id
  tags                = [module.dev_cluster.tag]
  namespaces          = []
  namespace_count     = 0
  name_prefix         = var.name_prefix
}
