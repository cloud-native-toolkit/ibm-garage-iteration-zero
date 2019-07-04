provider "helm" {
  namespace = "${var.tiller_namespace}"
  service_account = "${var.tiller_service_account_name}"

  kubernetes {
    config_path = "${var.iks_cluster_config_file}"
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
    name = "master.ingress.hostName"
    value = "jenkins.${var.iks_ingress_hostname}"
  }
//
//  set {
//    name = "master.ingress.tls[0].hosts[0]"
//    value = "jenkins.${var.iks_ingress_hostname}"
//  }
//
//  set {
//    name = "master.ingress.tls[0].secretName"
//    value = "${var.resource_group_name}-cluster"
//  }
}

resource "null_resource" "patch_jenkins_role" {
  depends_on = ["helm_release.jenkins_release"]

  provisioner "local-exec" {
    command = "kubectl patch -n tools roles/jenkins-schedule-agents --type='json' -p='[{\"op\": \"add\", \"path\": \"/rules/0/resources/0\", \"value\": \"secrets\"}]'"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
    }
  }
}

resource "helm_release" "ibmcloud_apikey_release" {
  name       = "ibmcloud-apikey"
  chart      = "${path.module}/ibmcloud-apikey"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  set {
    name = "apikey"
    value = "${var.ibmcloud_api_key}"
  }

  set {
    name = "resource_group"
    value = "${var.resource_group_name}"
  }
}

resource "helm_release" "jenkins-config" {
  name       = "jenkins-config"
  chart      = "${path.module}/jenkins-config"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  set {
    name = "jenkins.host"
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

resource "helm_release" "catalystdashboard_release" {
  name       = "catalyst-dashboard"
  chart      = "${path.module}/catalyst-dashboard"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  set {
    name = "ingress.hosts.0"
    value = "dashboard.${var.iks_ingress_hostname}"
  }

}

resource "helm_release" "pact_broker" {
  name       = "pact-broker"
  chart      = "${path.module}/pact-broker"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  set_string {
    name = "database.type"
    value = "sqlite"
  }

  set_string {
    name = "database.name"
    value = "pactbroker.sqlite"
  }

  set {
    name = "ingress.hosts.0.host"
    value = "pact.${var.iks_ingress_hostname}"
  }
}

data "helm_repository" "argo" {
  name = "argo"
  url  = "https://ibm-garage-cloud.github.io/argo-helm/"
}

resource "helm_release" "argocd_release" {
  name       = "argo-cd"
  repository = "${data.helm_repository.argo.metadata.0.name}"
  chart      = "argo-cd"
  version    = "0.2.3"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  set {
    name = "ingress.enabled"
    value = "true"
  }

  set {
    name = "ingress.ssl_passthrough"
    value = "false"
  }

  set {
    name = "ingress.hosts.0"
    value = "argocd.${var.iks_ingress_hostname}"
  }
}
