module "dev_infrastructure_watson_studio" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-watson-studio.git?ref=v1.1.1"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  name_prefix              = var.name_prefix
  tags                     = [module.dev_cluster.tag]
  plan                     = "standard-v1"
}
