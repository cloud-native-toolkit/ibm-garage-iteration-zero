data "ibm_resource_group" "iks_resource_group" {
  name = "${var.resource_group_name}"
}

data "ibm_container_cluster_config" "iks_cluster" {
  cluster_name_id = "${var.iks_cluster_id}"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
  config_dir      = "/root/.kube"
  region          = "${var.iks_cluster_region}"
}

provider "helm" {
  namespace = "${var.tiller_namespace}"
  service_account = "${var.tiller_service_account_name}"

  kubernetes {
    config_path = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
  }
}

data "helm_repository" "incubator" {
    name = "incubator"
    url  = "https://kubernetes-charts-incubator.storage.googleapis.com/"
}

resource "helm_release" "jenkins_release" {
  name       = "jenkins"
  repository = "${data.helm_repository.incubator.metadata.0.name}"
  chart      = "stable/jenkins"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  values = [
    "${file("${path.module}/jenkins-values.yaml")}"
  ]

  set {
    name = "Master.ingress.hostName"
    value = "jenkins.${var.iks_ingress_hostname}"
  }
}

resource "helm_release" "sonarqube_release" {
  name       = "sonarqube"
  chart      = "${path.module}/ibm-sonarqube"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  values = [
    "${file("${path.module}/sonarqube-values.yaml")}"
  ]

  set {
    name = "ingress.hosts.0"
    value = "sonarqube.${var.iks_ingress_hostname}"
  }

  set_string {
    name = "database.hostname"
    value = "${var.sonarqube_postgresql_hostname}"
  }

  set_string {
    name = "database.port"
    value = "${var.sonarqube_postgresql_port}"
  }

  set_string {
    name = "database.name"
    value = "${var.sonarqube_postgresql_database_name}"
  }

  set_string {
    name = "database.username"
    value = "${var.sonarqube_postgresql_service_account_username}"
  }

  set_string {
    name = "database.password"
    value = "${var.sonarqube_postgresql_service_account_password}"
  }
}
