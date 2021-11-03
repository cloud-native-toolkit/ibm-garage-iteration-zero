module "sysdig" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig.git?ref=v4.0.0"

  region                   = var.region
  resource_group_name      = module.dev_cluster.resource_group_name
  name_prefix              = var.name_prefix
  tags                     = [module.dev_cluster.tag]
  provision                = var.provision_sysdig == "true"
  name                     = var.sysdig_name
}
