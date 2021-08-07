module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git?ref=v2.3.0"

  names = split(",", var.resource_group_names)
}
