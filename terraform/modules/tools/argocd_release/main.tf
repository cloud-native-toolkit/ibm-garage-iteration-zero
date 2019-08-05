locals {
  tmp_dir      = "${path.cwd}/.tmp"
  chart_name   = "argo-cd"
  version      = "0.2.3"
  ingress_host = "argocd.${var.cluster_ingress_hostname}"
}

resource "null_resource" "argocd_release" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-argocd.sh ${local.chart_name} ${var.releases_namespace} ${local.version} ${local.ingress_host} ${path.module}/kustomize/argocd"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file : ""}"
      TMP_DIR        = "${local.tmp_dir}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/destroy-argocd.sh ${var.releases_namespace}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file : ""}"
    }
  }
}
