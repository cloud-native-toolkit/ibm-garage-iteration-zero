module "dev_serviceaccount_logdna-agent" {
  source = "../modules/cluster/serviceaccount"

  cluster_type         = "${var.cluster_type}"
  ibmcloud_api_key     = "${module.dev_cluster.ibmcloud_api_key}"
  server_url           = "${module.dev_cluster.server_url}"
  namespace            = "default"
  service_account_name = "logdna-agent"
  sscs                 = ["privileged"]
}

module "dev_infrastructure_logdna" {
  source = "../modules/infrastructure/logdna"

  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  resource_location        = "${module.dev_cluster.region}"
  cluster_id               = "${module.dev_cluster.id}"
  cluster_type             = "${var.cluster_type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  server_url               = "${module.dev_cluster.server_url}"
  ibmcloud_api_key         = "${module.dev_cluster.ibmcloud_api_key}"
  service_account_name     = "${var.cluster_type == "openshift" ? module.dev_serviceaccount_logdna-agent.name : "default"}"
}
