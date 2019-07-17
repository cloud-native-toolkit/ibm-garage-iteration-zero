resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
    }
  }
}

resource "null_resource" "fetch_jenkins_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm fetch --repo https://kubernetes-charts.storage.googleapis.com/ --untar --untardir ${path.module}/charts $${NAME}"

    environment = {
      NAME = "jenkins"
    }
  }
}

resource "null_resource" "jenkins_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_jenkins_helm"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set master.ingress.hostName=$${JENKINS_HOST} --values $${VALUES_FILE} > $${KUSTOMISE_PATH}"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/charts/jenkins"
      VALUES_FILE = "${path.module}/jenkins-values.yaml"
      JENKINS_HOST = "jenkins.${var.iks_ingress_hostname}"
      NAME = "jenkins"
      NAMESPACE = "${var.releases_namespace}"
      KUSTOMISE_PATH = "${path.module}/jenkins/base.yaml"
    }
  }
}

resource "null_resource" "jenkins_release" {
  depends_on = ["null_resource.jenkins_helm_template"]

  provisioner "local-exec" {
    command = "kustomize build ${path.module}/jenkins | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "wait_for_jenkins" {
  depends_on = ["null_resource.jenkins_release"]

  provisioner "local-exec" {
    command = "until checkPodRunning.sh jenkins; do echo '>>> waiting for Jenkins'; sleep 300; done; echo '>>> Jenkins has started'"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "ibmcloud_apikey_release" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --set apikey=$${APIKEY} --set resource_group=$${RESOURCE_GROUP} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/ibmcloud-apikey"
      APIKEY = "${var.ibmcloud_api_key}"
      RESOURCE_GROUP = "${var.resource_group_name}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "jenkins_config_release" {
  depends_on = ["null_resource.helm_init", "null_resource.jenkins_release"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --set jenkins.host=$${JENKINS_HOST} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/jenkins-config"
      JENKINS_HOST = "jenkins.${var.iks_ingress_hostname}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
