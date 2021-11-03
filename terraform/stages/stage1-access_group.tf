module "access_groups" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-access-group.git?ref=v1.0.0"

  resource_group_name  = module.resource_group.name
}
