module "dev_tekton_dashboard_namespace" {
  source = "github.com/ibm-garage-cloud/terraform-k8s-namespace.git?ref=v2.2.0"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  name                     = "openshift-pipelines"
}

module "dev_tools_tekton_release" {
  source = "github.com/ibm-garage-cloud/terraform-tools-tekton.git?ref=v1.3.3"

  cluster_type               = module.dev_cluster.type_code
  cluster_config_file_path   = module.dev_cluster.config_file_path
  cluster_ingress_hostname   = module.dev_cluster.ingress_hostname
  tools_namespace            = module.dev_tools_namespace.name
  tekton_dashboard_namespace = module.dev_tekton_dashboard_namespace.name
}

module "dev_tools_tekton_resources" {
  source = "github.com/ibm-garage-cloud/terraform-tools-tekton-resources.git?ref=v1.2.0"

  cluster_type             = module.dev_cluster.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  tekton_namespace         = module.dev_tools_tekton_release.namespace
  resource_namespace       = module.dev_tools_namespace.name
}
