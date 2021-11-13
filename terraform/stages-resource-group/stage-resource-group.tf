module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git?ref=v3.0.1"

  names = split(",", var.resource_group_names)
}
