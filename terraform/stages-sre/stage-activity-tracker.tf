module "sre_activity-tracker" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker.git?ref=v2.4.16"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  tags                     = []
  name_prefix              = var.name_prefix
  plan                     = "7-day"
  provision                = var.provision_activity_tracker == "true"
}
