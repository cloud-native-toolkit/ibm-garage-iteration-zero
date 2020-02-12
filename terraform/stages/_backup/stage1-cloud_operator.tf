module "dev_software_cloud_operator" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//self-managed/software/cloud_operator?ref=v2.1.0"

  resource_group_name = "${var.resource_group_name}"
  resource_location   = "${var.vlan_region}"
  cluster_config_file = "${module.dev_cluster.config_file_path}"
  ibmcloud_api_key    = "${module.dev_cluster.ibmcloud_api_key}"
}
