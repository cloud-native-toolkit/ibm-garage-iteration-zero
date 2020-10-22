module "dev_infrastructure_sysdig" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-sysdig.git?ref=v2.3.0"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_sysdig == "true"
  name                     = var.sysdig_name
  sync                     = module.dev_infrastructure_logdna.sync
}
