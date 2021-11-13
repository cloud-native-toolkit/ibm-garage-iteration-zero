module "sysdig-bind" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig-bind?ref=v1.2.2"

  resource_group_name = module.resource_group.name
  cluster_id = module.dev_cluster.id
  cluster_name = module.dev_cluster.name
  cluster_config_file_path = module.dev_cluster.platform.kubeconfig
  tools_namespace = module.dev_tools_namespace.name
  region = var.region
  private_endpoint = var.private_endpoint
  guid = module.sysdig.guid
  access_key = module.sysdig.access_key
  ibmcloud_api_key = var.ibmcloud_api_key
  namespace = var.observe_namespace
}
