resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"
  }
}

locals {
  ingress_host = "dashboard.${var.cluster_ingress_hostname}"
  release_yaml = "${path.cwd}/.tmp/catalyst-dashboard.yaml"
}

resource "null_resource" "catalystdashboard_helm_template" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set ingress.hosts.0=$${HOST} > ${local.release_yaml}"

    environment = {
      CHART      = "${path.module}/catalyst-dashboard"
      NAME       = "catalyst-dashboard"
      NAMESPACE  = "${var.releases_namespace}"
      HOST       = "${local.ingress_host}"
    }
  }
}

resource "null_resource" "catalystdashboard_release_openshift" {
  depends_on = ["null_resource.catalystdashboard_helm_template"]
  count      = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      NAMESPACE  = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "catalystdashboard_release_iks" {
  depends_on = ["null_resource.catalystdashboard_helm_template"]
  count      = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      NAMESPACE  = "${var.releases_namespace}"
    }
  }
}
