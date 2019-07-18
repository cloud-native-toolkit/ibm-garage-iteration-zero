resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"
  }
}

locals {
  chart_dir    = "${path.cwd}/.tmp/charts"
  ingress_host = "argocd.${var.cluster_ingress_hostname}"
  release_yaml = "${path.cwd}/.tmp/argocd.yaml"
}

resource "null_resource" "fetch_argocd_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "mkdir -p ${local.chart_dir} && helm fetch --repo https://ibm-garage-cloud.github.io/argo-helm/ --untar --untardir ${local.chart_dir} --version $${VERSION} $${NAME}"

    environment = {
      NAME = "argo-cd"
      VERSION = "0.2.3"
    }
  }
}

resource "null_resource" "argocd_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_argocd_helm"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set ingress.enabled=true --set ingress.ssl_passthrough=false --set ingress.hosts.0=$${HOST} > ${local.release_yaml}"

    environment = {
      CHART = "${local.chart_dir}/argo-cd"
      HOST = "${local.ingress_host}"
      NAME = "argo-cd"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "argocd_release_openshift" {
  depends_on = ["null_resource.argocd_helm_template"]
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "argocd_release_iks" {
  depends_on = ["null_resource.argocd_helm_template"]
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl apply -n $${NAMESPACE} -f ${local.release_yaml}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
