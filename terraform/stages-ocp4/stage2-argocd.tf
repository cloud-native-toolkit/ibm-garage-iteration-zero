module "dev_tools_argocd" {
  source = "github.com/ibm-garage-cloud/terraform-tools-argocd.git?ref=v2.10.1"

  cluster_config_file = module.dev_cluster.config_file_path
  cluster_type        = module.dev_cluster.type_code
  olm_namespace       = module.dev_software_olm.olm_namespace
  operator_namespace  = module.dev_software_olm.target_namespace
  ingress_subdomain   = module.dev_cluster.ingress_hostname
  app_namespace       = module.dev_tools_namespace.name
  name                = "argocd"
}
