data "ibm_resource_group" "iks_resource_group" {
  name = "${var.resource_group_name}"
}

data "ibm_container_cluster_config" "iks_cluster" {
  cluster_name_id   = "${var.cluster_name}"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
  config_dir        = "${var.kubeconfig_download_dir}/.kube"
  region            = "${var.iks_cluster_region}"
}

resource "null_resource" "namespace_delete_tools" {
  depends_on = ["data.ibm_container_cluster_config.iks_cluster"]

  provisioner "local-exec" {
    command = "deleteNamespace.sh $${NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      NAMESPACE = "tools"
    }
  }
}

resource "null_resource" "namespace_delete_dev" {
  depends_on = ["data.ibm_container_cluster_config.iks_cluster"]

  provisioner "local-exec" {
    command = "deleteNamespace.sh $${NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      NAMESPACE = "dev"
    }
  }
}

resource "null_resource" "namespace_delete_test" {
  depends_on = ["data.ibm_container_cluster_config.iks_cluster"]

  provisioner "local-exec" {
    command = "deleteNamespace.sh $${NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      NAMESPACE = "test"
    }
  }
}

resource "null_resource" "namespace_delete_prod" {
  depends_on = ["data.ibm_container_cluster_config.iks_cluster"]

  provisioner "local-exec" {
    command = "deleteNamespace.sh $${NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      NAMESPACE = "prod"
    }
  }
}
