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
    command = "helm fetch --repo https://kubernetes-charts.storage.googleapis.com/ --untar --untardir ${path.module} --version $${VERSION} $${NAME}"

    environment = {
      NAME = "jenkins"
      VERSION = "1.3.2"
    }
  }
}

resource "null_resource" "jenkins_release" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_jenkins_helm"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set master.ingress.hostName=$${JENKINS_HOST} --values $${VALUES_FILE} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/jenkins"
      VALUES_FILE = "${path.module}/jenkins-values.yaml"
      JENKINS_HOST = "jenkins.${var.iks_ingress_hostname}"
      NAME = "jenkins"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}

resource "null_resource" "patch_jenkins_role" {
  depends_on = ["null_resource.jenkins_release"]

  provisioner "local-exec" {
    command = "kubectl patch -n tools roles/jenkins-schedule-agents --type='json' -p='[{\"op\": \"add\", \"path\": \"/rules/0/resources/0\", \"value\": \"secrets\"}]'"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
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

resource "null_resource" "sonarqube_release" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --set ingress.hosts.0=$${HOST},database.hostname=$${DATABASE_HOST},database.port=$${DATABASE_PORT},database.name=$${DATABASE_NAME},database.username=$${DATABASE_USERNAME},database.password=$${DATABASE_PASSWORD} --values $${VALUES_FILE} | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/ibm-sonarqube"
      NAME = "sonarqube"
      NAMESPACE = "${var.releases_namespace}"
      VALUES_FILE = "${path.module}/sonarqube-values.yaml"
      HOST = "sonarqube.${var.iks_ingress_hostname}"
      DATABASE_HOST = "${var.sonarqube_postgresql_hostname}"
      DATABASE_PORT = "${var.sonarqube_postgresql_port}"
      DATABASE_NAME = "${var.sonarqube_postgresql_database_name}"
      DATABASE_USERNAME = "${var.sonarqube_postgresql_service_account_username}"
      DATABASE_PASSWORD = "${var.sonarqube_postgresql_service_account_password}"
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

resource "null_resource" "fetch_argocd_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm fetch --repo https://ibm-garage-cloud.github.io/argo-helm/ --untar --untardir ${path.module} --version $${VERSION} $${NAME}"

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
      CHART = "${path.module}/argo-cd"
      HOST = "argocd.${var.iks_ingress_hostname}"
      NAME = "argo-cd"
      NAMESPACE = "${var.releases_namespace}"
    }
  }
}
