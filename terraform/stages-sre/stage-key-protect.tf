module "sre_key-protect" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-key-protect.git?ref=v1.3.2"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_key_protect == "true"
}
