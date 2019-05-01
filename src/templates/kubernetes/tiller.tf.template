data "ibm_container_cluster_config" "catalyst_cluster" {
  cluster_name_id = "${ibm_container_cluster.catalyst_cluster.id}"
  resource_group_id = "${data.ibm_resource_group.catalyst_resource_group.id}"
  config_dir      = "/root/.kube"
  region          = "us-south"
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
        KUBECONFIG = "${data.ibm_container_cluster_config.catalyst_cluster.config_file_path}"
      }
    }
}
