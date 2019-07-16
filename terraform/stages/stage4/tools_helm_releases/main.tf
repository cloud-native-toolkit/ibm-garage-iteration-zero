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

resource "null_resource" "fetch_sonarqube_helm" {
  depends_on = ["null_resource.helm_init"]

  provisioner "local-exec" {
    command = "helm fetch --repo https://kubernetes-charts.storage.googleapis.com/ --untar --untardir ${path.module}/charts $${NAME}"

    environment = {
      NAME = "sonarqube"
    }
  }
}

resource "null_resource" "sonarqube_helm_template" {
  depends_on = ["null_resource.helm_init", "null_resource.fetch_sonarqube_helm"]

  provisioner "local-exec" {
    command = "helm template $${CHART} --namespace $${NAMESPACE} --name $${NAME} --values $${VALUES_FILE} --set ingress.hosts.0.name=$${HOST},postgresql.postgresServer=$${DATABASE_HOST},postgresql.service.port=$${DATABASE_PORT},postgresql.postgresDatabase=$${DATABASE_NAME},postgresql.postgresUser=$${DATABASE_USERNAME},postgresql.postgresPassword=$${DATABASE_PASSWORD} > $${KUSTOMISE_PATH}"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      CHART = "${path.module}/charts/sonarqube"
      NAME = "sonarqube"
      NAMESPACE = "${var.releases_namespace}"
      VALUES_FILE = "${path.module}/sonarqube-values.yaml"
      HOST = "sonarqube.${var.iks_ingress_hostname}"
      DATABASE_HOST = "${var.sonarqube_postgresql_hostname}"
      DATABASE_PORT = "${var.sonarqube_postgresql_port}"
      DATABASE_NAME = "${var.sonarqube_postgresql_database_name}"
      DATABASE_USERNAME = "${var.sonarqube_postgresql_service_account_username}"
      DATABASE_PASSWORD = "${var.sonarqube_postgresql_service_account_password}"
      KUSTOMISE_PATH = "${path.module}/sonarqube/base.yaml"
    }
  }
}

resource "null_resource" "sonarqube_release" {
  depends_on = ["null_resource.sonarqube_helm_template"]

  provisioner "local-exec" {
    command = "kustomize build ${path.module}/sonarqube | kubectl apply -n $${NAMESPACE} -f -"

    environment = {
      KUBECONFIG = "${var.iks_cluster_config_file}"
      NAMESPACE = "${var.releases_namespace}"
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

provider "kubernetes" {
  config_path = "${var.iks_cluster_config_file}"
}

resource "kubernetes_secret" "postgress_secret" {
  metadata {
    name = "postgres-db"
    annotations = {
      description = "Secret holds the config parameters for the postgres instance"
    }
    namespace = "tools"
  }

  data = {
    host = "${var.sonarqube_postgresql_hostname}"
    port = "${var.sonarqube_postgresql_port}"
    user = "${var.sonarqube_postgresql_service_account_username}"
    password = "${var.sonarqube_postgresql_service_account_password}"
    database = "${var.sonarqube_postgresql_database_name}"
  }
}
