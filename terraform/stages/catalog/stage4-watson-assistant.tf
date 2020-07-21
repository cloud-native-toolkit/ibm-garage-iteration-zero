module "dev_infrastructure_watson_assistant" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-watson-assistant.git?ref=v1.1.1"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  cluster_id               = module.dev_cluster.id
  name_prefix              = var.name_prefix
  namespace_count          = 0
  namespaces               = []
  tags                     = [module.dev_cluster.tag]
  plan                     = "standard"
}
