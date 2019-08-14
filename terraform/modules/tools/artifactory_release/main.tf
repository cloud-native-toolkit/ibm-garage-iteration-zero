locals {
  tmp_dir       = "${path.cwd}/.tmp"
  ingress_host  = "artifactory.${var.cluster_ingress_hostname}"
  ingress_url   = "http://${local.ingress_host}"
  values_file   = "${path.module}/artifactory-values.yaml"
}

resource "null_resource" "artifactory_release" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-artifactory.sh ${var.releases_namespace} ${local.ingress_host} ${local.values_file} ${var.service_account}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file}"
      TMP_DIR        = "${local.tmp_dir}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/destroy-artifactory.sh ${var.releases_namespace}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file}"
    }
  }
}
