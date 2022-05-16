module "access_groups" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-access-group.git?ref=v3.1.6"

  resource_group_name = module.resource_group.name
  provision           = var.access_group_provision
}
