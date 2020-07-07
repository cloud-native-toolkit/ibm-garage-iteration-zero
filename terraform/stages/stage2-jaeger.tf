module "dev_tools_jaeger" {
  source = "github.com/ibm-garage-cloud/terraform-tools-jaeger.git?ref=v1.6.0"

  cluster_config_file = module.dev_cluster.config_file_path
  cluster_type        = module.dev_cluster.type_code
  ingress_subdomain   = module.dev_cluster.ingress_hostname
  olm_namespace       = module.dev_software_olm.olm_namespace
  operator_namespace  = module.dev_software_olm.target_namespace
  app_namespace       = module.dev_tools_namespace.name
  name                = "jaeger"
}
