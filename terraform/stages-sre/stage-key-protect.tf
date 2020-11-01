module "sre_key-protect" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-key-protect.git?ref=v1.3.1"

  resource_group_name      = var.resource_group_name
  resource_location        = var.region
  name_prefix              = var.name_prefix
  provision                = var.provision_key_protect == "true"
}
