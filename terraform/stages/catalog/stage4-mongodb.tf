module "dev_infrastructure_mongodb" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-mongodb.git?ref=v1.0.0"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  cluster_id               = module.dev_cluster.id
  name_prefix              = var.name_prefix
  namespace_count          = 0
  namespaces               = []
  tags                     = [module.dev_cluster.tag]
  plan                     = "standard"
}
