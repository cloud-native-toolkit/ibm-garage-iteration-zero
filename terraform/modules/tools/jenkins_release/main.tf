resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"
  }
}

locals {
  tmp_dir                   = "${path.cwd}/.tmp"
  chart_dir                 = "${local.tmp_dir}/charts"
  kustomize_dir             = "${local.tmp_dir}/kustomize"
  jenkins_kustomize         = "${local.kustomize_dir}/jenkins/jenkins.yaml"
  ibmcloud_apikey_kustomize = "${local.kustomize_dir}/jenkins/ibmcloud_apikey.yaml"
  jenkins_config_kustomize  = "${local.kustomize_dir}/jenkins/jenkins_config.yaml"
  ingress_host              = "jenkins.${var.cluster_ingress_hostname}"
}

resource "null_resource" "fetch_jenkins_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "mkdir -p ${local.chart_dir} && helm fetch --repo https://kubernetes-charts.storage.googleapis.com/ --untar --untardir ${local.chart_dir} $${NAME}"

    environment = {
      NAME = "jenkins"
    }
  }
}

resource "null_resource" "jenkins_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_jenkins_helm"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set master.ingress.hostName=$${JENKINS_HOST} --values $${VALUES_FILE} > ${local.jenkins_kustomize}"

    environment = {
      CHART = "${local.chart_dir}/jenkins"
      VALUES_FILE = "${path.module}/jenkins-values.yaml"
      JENKINS_HOST = "jenkins.${var.cluster_ingress_hostname}"
      NAME = "jenkins"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "copy_kustomize_config" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.kustomize_dir} && cp -R ${path.module}/jenkins ${local.kustomize_dir}"
  }
}

resource "null_resource" "ibmcloud_apikey_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.copy_kustomize_config"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --set apikey=$${APIKEY} --set resource_group=$${RESOURCE_GROUP} --set server_url=$${SERVER_URL} --set cluster_type=$${CLUSTER_TYPE} --set cluster_name=$${CLUSTER_NAME} > ${local.ibmcloud_apikey_kustomize}"

    environment = {
      CHART          = "${path.module}/ibmcloud-apikey"
      APIKEY         = "${var.ibmcloud_api_key}"
      RESOURCE_GROUP = "${var.resource_group_name}"
      SERVER_URL     = "${var.server_url}"
      CLUSTER_TYPE   = "${var.cluster_type}"
      CLUSTER_NAME   = "${var.cluster_name}"
      NAMESPACE      = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "jenkins_config_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.copy_kustomize_config"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --set jenkins.host=$${JENKINS_HOST} > ${local.jenkins_config_kustomize}"

    environment = {
      CHART        = "${path.module}/jenkins-config"
      JENKINS_HOST = "${local.ingress_host}"
      NAMESPACE    = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "ibmcloud_apikey_release" {
  depends_on = ["null_resource.ibmcloud_apikey_helm_template"]
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "oc project $${NAMESPACE} && kubectl apply -f ${local.ibmcloud_apikey_kustomize}"

    environment = {
      NAMESPACE    = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "jenkins_release_openshift" {
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "oc project $${NAMESPACE} && oc new-app jenkins-persistent"

    environment = {
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "jenkins_release_iks" {
  depends_on = ["null_resource.jenkins_helm_template", "null_resource.copy_kustomize_config"]
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kustomize build $${KUSTOMIZE_PATH} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUSTOMIZE_PATH = "${local.kustomize_dir}/jenkins"
      KUBECONFIG = "${var.cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "wait_for_jenkins_iks" {
  depends_on = ["null_resource.jenkins_release_iks"]
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "until ${path.module}/scripts/checkPodRunning.sh jenkins; do echo '>>> waiting for Jenkins'; sleep 300; done; echo '>>> Jenkins has started'"

    environment = {
      KUBECONFIG = "${var.cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
