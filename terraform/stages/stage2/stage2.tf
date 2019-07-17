module "dev_tools_ibmcloud" {
  source = "./tools_ibmcloud"

  resource_group_name = "${module.dev_iks_cluster.resource_group_name}"
  resource_location   = "${module.dev_iks_cluster.iks_cluster_region}"
}
