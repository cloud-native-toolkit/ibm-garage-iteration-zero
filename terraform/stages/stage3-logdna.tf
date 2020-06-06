module "dev_serviceaccount_logdna-agent" {
  source = "github.com/ibm-garage-cloud/terraform-cluster-serviceaccount.git?ref=v1.3.0"

  cluster_type             = var.cluster_type
  cluster_config_file_path = module.dev_cluster.config_file_path
  namespace                = module.dev_sre_namespace.name
  service_account_name     = "logdna-agent"
  sscs                     = ["privileged"]
}

module "dev_infrastructure_logdna" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-logdna.git?ref=v1.1.0"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  cluster_type             = var.cluster_type
  cluster_config_file_path = module.dev_cluster.config_file_path
  service_account_name     = module.dev_serviceaccount_logdna-agent.name
  namespace                = module.dev_serviceaccount_logdna-agent.namespace
  name_prefix              = var.name_prefix
  exists                   = var.logdna_exists == "true"
  name                     = var.logdna_name
}
