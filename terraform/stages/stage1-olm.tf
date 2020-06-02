module "dev_software_olm" {
  source = "github.com/ibm-garage-cloud/terraform-software-olm.git?ref=v1.1.0"

  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_version          = ""
  cluster_type             = module.dev_cluster.type_code
  olm_version              = "0.14.1"
}
