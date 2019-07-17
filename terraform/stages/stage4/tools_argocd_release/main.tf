resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
    }
  }
}

resource "null_resource" "fetch_argocd_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm fetch --repo https://ibm-garage-cloud.github.io/argo-helm/ --untar --untardir ${path.module}/charts --version $${VERSION} $${NAME}"

    environment = {
      NAME = "argo-cd"
      VERSION = "0.2.3"
    }
  }
}

resource "null_resource" "argocd_release" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_argocd_helm"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set ingress.enabled=true --set ingress.ssl_passthrough=false --set ingress.hosts.0=$${HOST} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/charts/argo-cd"
      HOST = "argocd.${var.iks_ingress_hostname}"
      NAME = "argo-cd"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
