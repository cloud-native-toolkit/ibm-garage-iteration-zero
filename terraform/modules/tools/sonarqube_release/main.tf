resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"
  }
}

locals {
  tmp_dir        = "${path.cwd}/.tmp"
  chart_dir      = "${local.tmp_dir}/charts"
  kustomize_root = "${local.tmp_dir}/kustomize"
  kustomize_path = "${local.kustomize_root}/sonarqube"
  ingress_host   = "sonarqube.${var.cluster_ingress_hostname}"
  release_yaml   = "${path.cwd}/.tmp/sonarqube.yaml"
}

resource "null_resource" "fetch_sonarqube_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "mkdir -p ${local.chart_dir} && helm fetch --repo https://kubernetes-charts.storage.googleapis.com/ --untar --untardir ${local.chart_dir} --version $${VERSION} $${NAME}"

    environment = {
      NAME    = "sonarqube"
      VERSION = "${var.helm_version}"
    }
  }
}

resource "null_resource" "copy_kustomize_config" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.kustomize_root} && cp -R ${path.module}/sonarqube ${local.kustomize_root} && echo \"  url: http://${local.ingress_host}\" >> ${local.kustomize_path}/secret.yaml"
  }
}

resource "null_resource" "sonarqube_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_sonarqube_helm", "null_resource.copy_kustomize_config"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --values $${VALUES_FILE} --set ingress.hosts.0.name=$${HOST},postgresql.postgresServer=$${DATABASE_HOST},postgresql.service.port=$${DATABASE_PORT},postgresql.postgresDatabase=$${DATABASE_NAME},postgresql.postgresUser=$${DATABASE_USERNAME},postgresql.postgresPassword=$${DATABASE_PASSWORD} > $${KUSTOMISE_PATH}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      CHART = "${local.chart_dir}/sonarqube"
      NAME = "sonarqube"
      NAMESPACE = "${var.releases_namespace}"
      VALUES_FILE = "${path.module}/sonarqube-values.yaml"
      HOST = "${local.ingress_host}"
      DATABASE_HOST = "${var.postgresql_hostname}"
      DATABASE_PORT = "${var.postgresql_port}"
      DATABASE_NAME = "${var.postgresql_database_name}"
      DATABASE_USERNAME = "${var.postgresql_username}"
      DATABASE_PASSWORD = "${var.postgresql_password}"
      KUSTOMISE_PATH = "${local.kustomize_path}/base.yaml"
    }
  }
}

resource "null_resource" "sonarqube_kustomize" {
  depends_on = ["null_resource.sonarqube_helm_template"]

  provisioner "local-exec" {
    command = "kustomize build ${local.kustomize_path} > ${local.release_yaml}"
  }
}

resource "null_resource" "sonarqube_release_openshift" {
  depends_on = ["null_resource.sonarqube_kustomize"]
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "sonarqube_release_iks" {
  depends_on = ["null_resource.sonarqube_kustomize"]
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "wait_for_sonarqube_openshift" {
  depends_on = ["null_resource.sonarqube_release_openshift"]
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "until ${path.module}/scripts/checkPodRunning.sh sonarqube-sonarqube no-login; do echo '>>> waiting for SonarQube'; sleep 300; done; echo '>>> SonarQube has started'"

    environment = {
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "wait_for_sonarqube_iks" {
  depends_on = ["null_resource.sonarqube_release_iks"]
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "until ${path.module}/scripts/checkPodRunning.sh sonarqube-sonarqube; do echo '>>> waiting for SonarQube'; sleep 300; done; echo '>>> SonarQube has started'"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
