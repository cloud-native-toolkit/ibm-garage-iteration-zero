data "ibm_container_cluster_config" "catalyst_cluster" {
  cluster_name_id = "${ibm_container_cluster.catalyst_cluster.id}"
  resource_group_id = "${data.ibm_resource_group.catalyst_resource_group.id}"
  config_dir      = "/root/.kube"
  region          = "us-south"
}

provider "kubernetes" {
  config_path = "${data.ibm_container_cluster_config.catalyst_cluster.config_file_path}"
}
