module "sre_activity-tracker" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-activity-tracker.git?ref=v1.1.1"

  resource_group_name      = module.dev_cluster.resource_group_name
  resource_location        = module.dev_cluster.region
  name_prefix              = var.name_prefix
  provision                = var.provision_activity_tracker == "true"
}
