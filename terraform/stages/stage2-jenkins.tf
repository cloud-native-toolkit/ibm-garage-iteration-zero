module "dev_tools_jenkins" {
  source = "github.com/ibm-garage-cloud/terraform-tools-jenkins.git?ref=v1.4.3"

  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_type             = module.dev_cluster.type
  tls_secret_name          = module.dev_cluster.tls_secret_name
  server_url               = module.dev_cluster.server_url
  tools_namespace          = module.dev_tools_namespace.name
}
