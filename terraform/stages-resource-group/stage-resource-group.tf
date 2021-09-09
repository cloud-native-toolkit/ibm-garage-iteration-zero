module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git?ref=v2.4.6"

  names = split(",", var.resource_group_names)
}
