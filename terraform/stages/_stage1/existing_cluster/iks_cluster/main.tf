data "ibm_resource_group" "iks_resource_group" {
  name = "${var.resource_group_name}"
}

data "ibm_container_cluster_config" "iks_cluster" {
  cluster_name_id   = "${var.cluster_name}"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
  config_dir        = "${var.kubeconfig_download_dir}/.kube"
  region            = "${var.iks_cluster_region}"
}
