
provider "kubernetes" {
  config_path = "${var.iks_config_file_path}"
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
      CLUSTER_NAME = "${var.cluster_name}"
    }
  }
}

resource "null_resource" "tools_tls_secret" {
  provisioner "local-exec" {
    command = "copy-secret-to-namespace.sh $${SECRET_NAME} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.iks_config_file_path}"
      SECRET_NAME = "${var.cluster_name}"
      CLUSTER_NAMESPACE = "tools"
    }
  }
}

resource "null_resource" "tools_pull_secret" {
  depends_on = ["null_resource.cluster_pull_secret"]

  provisioner "local-exec" {
    command = "setup-namespace-pull-secrets.sh $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.iks_config_file_path}"
      CLUSTER_NAMESPACE = "tools"
    }
  }
}

resource "null_resource" "dev_tls_secret" {
  provisioner "local-exec" {
    command = "copy-secret-to-namespace.sh $${SECRET_NAME} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.iks_config_file_path}"
      SECRET_NAME = "${var.cluster_name}"
      CLUSTER_NAMESPACE = "dev"
    }
  }
}

resource "null_resource" "dev_pull_secret" {
  depends_on = ["null_resource.cluster_pull_secret"]

  provisioner "local-exec" {
    command = "setup-namespace-pull-secrets.sh $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.iks_config_file_path}"
      CLUSTER_NAMESPACE = "dev"
    }
  }
}

resource "null_resource" "test_tls_secret" {
  provisioner "local-exec" {
    command = "copy-secret-to-namespace.sh $${SECRET_NAME} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.iks_config_file_path}"
      SECRET_NAME = "${var.cluster_name}"
      CLUSTER_NAMESPACE = "test"
    }
  }
}

resource "null_resource" "test_pull_secret" {
  depends_on = ["null_resource.cluster_pull_secret"]

  provisioner "local-exec" {
    command = "setup-namespace-pull-secrets.sh $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.iks_config_file_path}"
      CLUSTER_NAMESPACE = "test"
    }
  }
}
