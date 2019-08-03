resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"
  }
}

locals {
  ingress_host  = "pact.${var.cluster_ingress_hostname}"
  ingress_url   = "http://${local.ingress_host}"
  secret_name   = "pactbroker-access"
  database_type = "sqlite"
  database_name = "pactbroker.sqlite"
  release_yaml  = "${path.cwd}/.tmp/pactbroker.yaml"
}

resource "null_resource" "pactbroker_helm_template" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set ingress.hosts.0.host=$${HOST} --set database.type=$${DATABASE_TYPE} --set database.name=$${DATABASE_NAME} > ${local.release_yaml}"

    environment = {
      CHART = "${path.module}/pact-broker"
      NAME = "pact-broker"
      NAMESPACE = "${var.releases_namespace}"
      HOST = "${local.ingress_host}"
      DATABASE_TYPE = "${local.database_type}"
      DATABASE_NAME = "${local.database_name}"
    }
  }
}

resource "null_resource" "pactbroker_release_openshift" {
  depends_on = ["null_resource.pactbroker_helm_template"]
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "pactbroker_release_iks" {
  depends_on = ["null_resource.pactbroker_helm_template"]
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
