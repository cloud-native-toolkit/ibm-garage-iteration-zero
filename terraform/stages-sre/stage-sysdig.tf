module "dev_infrastructure_sysdig" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig.git?ref=v2.3.3"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_sysdig == "true"
  name                     = var.sysdig_name
  sync                     = module.dev_infrastructure_logdna.sync
}
