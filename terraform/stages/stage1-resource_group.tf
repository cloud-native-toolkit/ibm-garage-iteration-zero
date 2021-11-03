module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git?ref=v2.4.6"

  provision           = var.resource_group_provision
  resource_group_name = var.resource_group_name
}
