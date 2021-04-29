module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git?ref=v1.4.1"

  names = split(",", var.resource_group_names)
}
