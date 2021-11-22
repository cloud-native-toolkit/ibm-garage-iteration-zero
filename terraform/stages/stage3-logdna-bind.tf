module "ibm-logdna-bind" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-logdna-bind?ref=v1.2.2"

  cluster_id = module.dev_cluster.id
  cluster_name = module.dev_cluster.name
  resource_group_name = module.resource_group.name
  sync = module.sysdig-bind.sync
  logdna_id = module.logdna.guid
  region = var.region
  private_endpoint = var.private_endpoint
  ibmcloud_api_key = var.ibmcloud_api_key
}
