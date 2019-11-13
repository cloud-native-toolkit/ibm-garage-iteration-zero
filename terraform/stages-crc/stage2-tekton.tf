module "dev_tools_tekton_release" {
  source = "../mike/tekton"

  cluster_type             = "${module.dev_cluster.type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  cluster_ingress_hostname = "${module.dev_cluster.ingress_hostname}"
}
