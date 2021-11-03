module "logdna" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-logdna.git?ref=v4.0.0"

  region                   = var.region
  resource_group_name      = module.dev_cluster.resource_group_name
  name_prefix              = var.name_prefix
  provision                = var.provision_logdna == "true"
  name                     = var.logdna_name
}
