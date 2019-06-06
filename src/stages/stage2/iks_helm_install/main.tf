data "ibm_resource_group" "iks_resource_group" {
  name = "${var.resource_group_name}"
}

data "ibm_container_cluster_config" "iks_cluster" {
  cluster_name_id = "${var.iks_cluster_id}"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
  config_dir      = "${var.kubeconfig_download_dir}/.kube"
  region          = "${var.iks_cluster_region}"
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
