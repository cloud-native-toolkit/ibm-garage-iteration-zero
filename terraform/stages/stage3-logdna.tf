module "dev_serviceaccount_logdna-agent" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cluster/serviceaccount?ref=v1.0.0"

  cluster_type             = "${var.cluster_type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  namespace                = "default"
  service_account_name     = "logdna-agent"
  sscs                     = ["privileged"]
}

module "dev_infrastructure_logdna" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//infrastructure/logdna?ref=v1.0.0"

  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  resource_location        = "${module.dev_cluster.region}"
  cluster_type             = "${var.cluster_type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  service_account_name     = "${module.dev_serviceaccount_logdna-agent.name}"
}
