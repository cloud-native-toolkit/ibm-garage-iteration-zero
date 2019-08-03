provider "null" {
}

locals {
  tmp_dir               = "${path.cwd}/.tmp"
  secret_name           = "jenkins-access"
  ingress_host          = "jenkins.${var.cluster_ingress_hostname}"
  ingress_url           = "${var.cluster_type == "openshift" ? "https" : "http"}://${local.ingress_host}"
  values_file           = "${path.module}/jenkins-values.yaml"
  kustomize_template    = "${path.module}/kustomize/jenkins"
  jenkins_config_chart  = "${path.module}/charts/jenkins-config"
  ibmcloud_apikey_chart = "${path.module}/charts/ibmcloud-apikey"
  storage_class         = "ibmc-file-gold"
  volume_capacity       = "20Gi"
}

resource "null_resource" "ibmcloud_apikey_release" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-ibmcloud-apikey.sh ${local.ibmcloud_apikey_chart} ${var.releases_namespace} ${var.ibmcloud_api_key} ${var.resource_group_name} ${var.server_url} ${var.cluster_type} ${var.cluster_name} ${var.cluster_ingress_hostname}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file : ""}"
      TMP_DIR        = "${local.tmp_dir}"
    }
  }
}

resource "null_resource" "jenkins_release_iks" {
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-jenkins.sh ${local.jenkins_config_chart} ${var.releases_namespace} ${local.ingress_host} ${local.values_file} ${local.kustomize_template}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      TMP_DIR    = "${local.tmp_dir}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/destroy-jenkins.sh ${var.releases_namespace}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file}"
    }
  }
}

resource "null_resource" "jenkins_release_openshift" {
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-jenkins-openshift.sh ${var.releases_namespace} ${local.storage_class} ${local.volume_capacity}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/destroy-jenkins.sh ${var.releases_namespace}"
  }
}
