module "dev_infrastructure_cos" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-object-storage?ref=v2.0.0"

  resource_group_name = var.resource_group_name
  resource_location   = "global"
  name_prefix         = var.name_prefix
  provision           = var.provision_object_storage == "true"
  name                = var.object_storage_name
}
