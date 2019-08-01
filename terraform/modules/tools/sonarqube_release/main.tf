locals {
  tmp_dir                = "${path.cwd}/.tmp"
  sonarqube_secret_chart = "${path.module}/charts/sonarqube-access"
  ingress_host           = "sonarqube.${var.cluster_ingress_hostname}"
  values_file            = "${path.module}/sonarqube-values.yaml"
  kustomize_template     = "${path.module}/kustomize/sonarqube"
}

resource "null_resource" "sonarqube_release" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-sonarqube.sh ${local.sonarqube_secret_chart} ${var.releases_namespace} ${local.ingress_host} ${local.values_file} ${local.kustomize_template} ${var.helm_version} ${var.service_account_name}"

    environment = {
      KUBECONFIG_IKS    = "${var.cluster_type != "openshift" ? var.cluster_config_file : ""}"
      TMP_DIR           = "${local.tmp_dir}"
      DATABASE_HOST     = "${var.postgresql_hostname}"
      DATABASE_PORT     = "${var.postgresql_port}"
      DATABASE_NAME     = "${var.postgresql_database_name}"
      DATABASE_USERNAME = "${var.postgresql_username}"
      DATABASE_PASSWORD = "${var.postgresql_password}"
    }
  }
}
