data "ibm_resource_group" "iks_resource_group" {
  name = "${var.resource_group_name}"
}

data "ibm_container_cluster_config" "iks_cluster" {
  cluster_name_id   = "${var.iks_cluster_id}"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
  config_dir        = "${var.kubeconfig_download_dir}/.kube"
  region            = "${var.iks_cluster_region}"
}

provider "kubernetes" {
  config_path = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
}

resource "kubernetes_namespace" "tools_namespace" {
  metadata {
    name = "tools"
  }
}

resource "kubernetes_namespace" "dev_namespace" {
  metadata {
    name = "dev"
  }
}
resource "kubernetes_namespace" "test_namespace" {
  metadata {
    name = "test"
  }
}

resource "kubernetes_namespace" "prod_namespace" {
  metadata {
    name = "prod"
  }
}

resource "null_resource" "cluster_pull_secret" {
  provisioner "local-exec" {
    command = "cluster-pull-secret-apply.sh"

    environment = {
      APIKEY = "${var.ibmcloud_api_key}"
      RESOURCE_GROUP = "${var.resource_group_name}"
      REGION = "${var.iks_cluster_region}"
      CLUSTER_NAME = "${var.resource_group_name}-cluster"
    }
  }
}

resource "null_resource" "tools_tls_secret" {
  provisioner "local-exec" {
    command = "copy-secret-to-namespace.sh $${SECRET_NAME} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      SECRET_NAME = "${var.resource_group_name}-cluster"
      CLUSTER_NAMESPACE = "tools"
    }
  }
}

resource "null_resource" "tools_pull_secret" {
  depends_on = ["null_resource.cluster_pull_secret"]

  provisioner "local-exec" {
    command = "setup-namespace-pull-secrets.sh $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      CLUSTER_NAMESPACE = "tools"
    }
  }
}

resource "null_resource" "dev_tls_secret" {
  provisioner "local-exec" {
    command = "copy-secret-to-namespace.sh $${SECRET_NAME} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      SECRET_NAME = "${var.resource_group_name}-cluster"
      CLUSTER_NAMESPACE = "dev"
    }
  }
}

resource "null_resource" "dev_pull_secret" {
  depends_on = ["null_resource.cluster_pull_secret"]

  provisioner "local-exec" {
    command = "setup-namespace-pull-secrets.sh $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      CLUSTER_NAMESPACE = "dev"
    }
  }
}

resource "null_resource" "test_tls_secret" {
  provisioner "local-exec" {
    command = "copy-secret-to-namespace.sh $${SECRET_NAME} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      SECRET_NAME = "${var.resource_group_name}-cluster"
      CLUSTER_NAMESPACE = "test"
    }
  }
}

resource "null_resource" "test_pull_secret" {
  depends_on = ["null_resource.cluster_pull_secret"]

  provisioner "local-exec" {
    command = "setup-namespace-pull-secrets.sh $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
      CLUSTER_NAMESPACE = "test"
    }
  }
}

resource "kubernetes_service_account" "tiller_service_account" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller_admin_binding" {
  metadata {
    name = "${kubernetes_service_account.tiller_service_account.metadata.0.name}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name = "${kubernetes_service_account.tiller_service_account.metadata.0.name}"
    namespace = "${kubernetes_service_account.tiller_service_account.metadata.0.namespace}"
  }

  provisioner "local-exec" {
    command = "helm init --service-account ${kubernetes_service_account.tiller_service_account.metadata.0.name}"

    environment = {
      KUBECONFIG = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
    }
  }
}
