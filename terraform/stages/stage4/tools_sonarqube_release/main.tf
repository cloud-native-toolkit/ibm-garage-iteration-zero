resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
    }
  }
}

resource "null_resource" "fetch_sonarqube_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm fetch --repo https://kubernetes-charts.storage.googleapis.com/ --untar --untardir ${path.module}/charts $${NAME}"

    environment = {
      NAME = "sonarqube"
    }
  }
}

resource "null_resource" "sonarqube_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_sonarqube_helm"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --values $${VALUES_FILE} --set ingress.hosts.0.name=$${HOST},postgresql.postgresServer=$${DATABASE_HOST},postgresql.service.port=$${DATABASE_PORT},postgresql.postgresDatabase=$${DATABASE_NAME},postgresql.postgresUser=$${DATABASE_USERNAME},postgresql.postgresPassword=$${DATABASE_PASSWORD} > $${KUSTOMISE_PATH}"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/charts/sonarqube"
      NAME = "sonarqube"
      NAMESPACE = "${var.releases_namespace}"
      VALUES_FILE = "${path.module}/sonarqube-values.yaml"
      HOST = "sonarqube.${var.iks_ingress_hostname}"
      DATABASE_HOST = "${var.sonarqube_postgresql_hostname}"
      DATABASE_PORT = "${var.sonarqube_postgresql_port}"
      DATABASE_NAME = "${var.sonarqube_postgresql_database_name}"
      DATABASE_USERNAME = "${var.sonarqube_postgresql_service_account_username}"
      DATABASE_PASSWORD = "${var.sonarqube_postgresql_service_account_password}"
      KUSTOMISE_PATH = "${path.module}/sonarqube/base.yaml"
    }
  }
}

resource "null_resource" "sonarqube_release" {
  depends_on = ["null_resource.sonarqube_helm_template"]

  provisioner "local-exec" {
    command = "kustomize build ${path.module}/sonarqube | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "wait_for_sonarqube" {
  depends_on = ["null_resource.sonarqube_release"]

  provisioner "local-exec" {
    command = "until checkPodRunning.sh sonarqube-sonarqube; do echo '>>> waiting for SonarQube'; sleep 300; done; echo '>>> SonarQube has started'"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
