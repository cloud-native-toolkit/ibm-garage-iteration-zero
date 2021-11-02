module "access_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-access-group.git?ref=v3.0.0"

  resourceGroupNames   = split(",", var.resource_group_names)
  createResourceGroups = var.create_resource_groups == "true"
}
