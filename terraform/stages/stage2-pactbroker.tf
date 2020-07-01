module "dev_tools_pactbroker_release" {
  source = "github.com/ibm-garage-cloud/terraform-tools-pactbroker.git?ref=v1.3.0"

  cluster_ingress_hostname                      = module.dev_cluster.ingress_hostname
  cluster_config_file                           = module.dev_cluster.config_file_path
  cluster_type                                  = module.dev_cluster.type_code
  releases_namespace                            = module.dev_cluster_namespaces.tools_namespace_name
  tls_secret_name                               = module.dev_cluster.tls_secret_name
}
