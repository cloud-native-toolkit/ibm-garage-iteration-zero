provider "null" {
}

locals {
  namespaces  = ["${var.tools_namespace}", "${var.dev_namespace}", "${var.test_namespace}", "${var.staging_namespace}"]
}

resource "null_resource" "delete_namespaces" {
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/deleteNamespace.sh ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }
}

resource "null_resource" "create_namespaces" {
  depends_on = ["null_resource.delete_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/createNamespace.sh ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/deleteNamespace.sh ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }
}

resource "null_resource" "create_cluster_pull_secret_iks" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/cluster-pull-secret-apply.sh ${var.cluster_name}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }
}

resource "null_resource" "copy_tls_secrets" {
  depends_on = ["null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-secret-to-namespace.sh ${var.cluster_name} ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }
}

resource "null_resource" "copy_apikey_secret" {
  depends_on = ["null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-secret-to-namespace.sh ibmcloud-apikey ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }
}

resource "null_resource" "create_pull_secrets" {
  depends_on = ["null_resource.create_cluster_pull_secret_iks", "null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-namespace-pull-secrets.sh ${var.cluster_name} ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }
}

resource "null_resource" "copy_cloud_configmap" {
  depends_on = ["null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-configmap-to-namespace.sh ibmcloud-config ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_config_file_path}"
    }
  }
}
