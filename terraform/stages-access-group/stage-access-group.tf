module "access_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-access-group.git?ref=v1.2.1"

  resourceGroupNames   = split(",", var.resource_group_names)
  createResourceGroups = var.create_resource_groups == "true"
}
