resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
    }
  }
}

resource "null_resource" "catalystdashboard_release" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set ingress.hosts.0=$${HOST} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/catalyst-dashboard"
      NAME = "catalyst-dashboard"
      NAMESPACE = "${var.releases_namespace}"
      HOST = "dashboard.${var.iks_ingress_hostname}"
    }
  }
}
