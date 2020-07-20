module "dev_infrastructure_sysdig" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-sysdig.git?ref=v1.1.0"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_type             = module.dev_cluster.type_code
  namespace                = module.dev_sre_namespace.name
  tags                     = []
  exists                   = var.sysdig_exists == "true"
  name                     = var.sysdig_name
}
