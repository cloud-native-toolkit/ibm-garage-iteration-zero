resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
    }
  }
}

resource "null_resource" "pactbroker_release" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set ingress.hosts.0.host=$${HOST},database.type=$${DATABASE_TYPE},database.name=$${DATABASE_NAME} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/pact-broker"
      NAME = "pact-broker"
      NAMESPACE = "${var.releases_namespace}"
      HOST = "pact.${var.iks_ingress_hostname}"
      DATABASE_TYPE = "sqlite"
      DATABASE_NAME = "pactbroker.sqlite"
    }
  }
}
