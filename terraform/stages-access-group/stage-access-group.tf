module "access_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-access-group.git?ref=v2.3.0"

  resourceGroupNames   = split(",", var.resource_group_names)
  createResourceGroups = var.create_resource_groups == "true"
}
