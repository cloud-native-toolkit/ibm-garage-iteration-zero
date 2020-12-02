module "dev_infrastructure_logdna" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-logdna.git?ref=v2.4.3"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_logdna == "true"
  name                     = var.logdna_name
}
