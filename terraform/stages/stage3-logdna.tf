module "dev_serviceaccount_logdna-agent" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/serviceaccount?ref=v2.0.18"

  cluster_type             = "${var.cluster_type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  namespace                = "${module.dev_cluster_namespaces.tools_namespace_name}"
  service_account_name     = "logdna-agent"
  sscs                     = ["privileged"]
}

module "dev_infrastructure_logdna" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/operator-services/logdna?ref=v2.1.8"

  resource_group_name      = "${module.dev_cluster.resource_group_name}"
  resource_location        = "${module.dev_cluster.region}"
  cluster_type             = "${var.cluster_type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  service_account_name     = "${module.dev_serviceaccount_logdna-agent.name}"
  name_prefix              = "${var.name_prefix}"
  namespace                = "${module.dev_cluster_namespaces.tools_namespace_name}"
  service_namespace        = "${module.dev_software_cloud_operator.namespace}"
}
