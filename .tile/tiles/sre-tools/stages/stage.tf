terraform {
  required_version = "> 0.12.0"
}

module "sre_logdna" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-logdna.git?ref=v2.0.0"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_logdna == "true"
  name                     = var.logdna_name
}

module "sre_sysdig" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-sysdig.git?ref=v2.0.0"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_sysdig == "true"
  name                     = var.sysdig_name
}

module "sre_activity-tracker" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-activity-tracker.git?ref=v1.1.1"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_activity_tracker == "true"
}
