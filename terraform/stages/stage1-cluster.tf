module "dev_cluster" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-container-platform.git?ref=v1.19.1"

  resource_group_name     = var.resource_group_name
  cluster_name            = var.cluster_name
  private_vlan_id         = var.private_vlan_id
  public_vlan_id          = var.public_vlan_id
  vlan_datacenter         = var.vlan_datacenter
  cluster_region          = var.vlan_region != "" ? var.vlan_region : var.region
  flavor                  = var.flavor
  cluster_worker_count    = var.cluster_worker_count
  cluster_hardware        = var.cluster_hardware
  cluster_type            = var.cluster_type
  cluster_exists          = var.cluster_exists
  ibmcloud_api_key        = var.ibmcloud_api_key
  name_prefix             = var.name_prefix
  is_vpc                  = var.vpc_cluster == "true"
  vpc_zone_names          = split(",", var.vpc_zone_names)
  provision_cos           = var.cluster_provision_cos == "true"
  cos_name                = var.cos_name
}
