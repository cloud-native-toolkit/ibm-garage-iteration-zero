module "dev_serviceaccount_useroot" {
  source = "../modules/cluster/serviceaccount"


  cluster_type         = "${var.cluster_type}"
  ibmcloud_api_key     = "${module.dev_cluster.ibmcloud_api_key}"
  server_url           = "${module.dev_cluster.server_url}"
  namespace            = "${module.dev_cluster_namespaces.tools_namespace_name}"
  service_account_name = "useroot"
  sscs                 = ["anyuid", "privileged"]
}
