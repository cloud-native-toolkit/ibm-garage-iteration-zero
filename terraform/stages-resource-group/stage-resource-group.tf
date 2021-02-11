module "resource_group" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-resource-group.git?ref=v1.4.0"

  names = split(",", var.resource_group_names)
}
