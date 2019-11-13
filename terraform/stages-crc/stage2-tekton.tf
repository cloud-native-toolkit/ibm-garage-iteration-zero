module "dev_tools_tekton_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/tekton_release?ref=dev"


  cluster_type             = "${module.dev_cluster.type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  cluster_ingress_hostname = "${module.dev_cluster.ingress_hostname}"
}
