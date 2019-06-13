provider "helm" {
  namespace = "${var.tiller_namespace}"
  service_account = "${var.tiller_service_account_name}"

  kubernetes {
    config_path = "${var.iks_cluster_config_file}"
  }
}

data "helm_repository" "incubator" {
    name = "incubator"
    url  = "https://seansund.github.io/charts/"
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
}

resource "helm_release" "ibmcloud_apikey_release" {
  name       = "ibmcloud-apikey"
  chart      = "${path.module}/ibmcloud-apikey"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  set {
    name = "ibmcloud.apikey"
    value = "${var.ibmcloud_api_key}"
  }
}

/* Sean to work on automating these steps
resource "null_resource" "jenkins-gen-token" {
  depends_on = ["helm_release.jenkins_release"]

  provisioner "local-exec" {
    command = "gen-token --url jenkins.${var.iks_ingress_hostname} --password $(kubectl get secret -n ${var.releases_namespace} jenkins -o jsonpath=\"{.data.jenkins-admin-password}\" | base64 --decode) --yaml > ${path.module}/jenkins-access-values.yaml"
  }
}

resource "helm_release" "jenkins-access" {
  depends_on = ["null_resource.jenkins-gen-token"]

  name       = "jenkins-access"
  chart      = "${path.module}/jenkins-access"
  namespace  = "${var.releases_namespace}"
  timeout    = 1200

  values = [
    "${file("${path.module}/jenkins-access-values.yaml")}"
  ]
}
*/

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
