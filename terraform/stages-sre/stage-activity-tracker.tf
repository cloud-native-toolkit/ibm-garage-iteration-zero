module "sre_activity-tracker" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-activity-tracker.git?ref=v1.0.0"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  tags                     = []
  name_prefix              = var.name_prefix
  plan                     = "7-day"
}
