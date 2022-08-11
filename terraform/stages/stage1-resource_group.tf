module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git?ref=v3.3.3"

  provision           = var.resource_group_provision
  resource_group_name = var.resource_group_name
}
