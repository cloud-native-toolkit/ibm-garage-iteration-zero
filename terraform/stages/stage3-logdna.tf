module "dev_infrastructure_logdna" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-logdna.git?ref=v2.1.2"

  cluster_id               = module.dev_cluster.name
  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  namespace                = module.dev_sre_namespace.name
  name_prefix              = var.name_prefix
  provision                = var.provision_logdna == "true"
  name                     = var.logdna_name
}
