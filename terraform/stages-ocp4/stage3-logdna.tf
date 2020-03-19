module "dev_serviceaccount_logdna-agent" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/serviceaccount?ref=v2.2.2"

  cluster_type             = var.cluster_type
  cluster_config_file_path = module.dev_cluster.config_file_path
  namespace                = module.dev_sre_namespace.tools_namespace_name
  service_account_name     = "logdna-agent"
  sscs                     = ["privileged"]
}

module "dev_infrastructure_logdna" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/logdna?ref=v2.2.12"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  cluster_type             = var.cluster_type
  cluster_config_file_path = module.dev_cluster.config_file_path
  service_account_name     = module.dev_serviceaccount_logdna-agent.name
  name_prefix              = var.name_prefix
  namespace                = module.dev_sre_namespace.tools_namespace_name
}
