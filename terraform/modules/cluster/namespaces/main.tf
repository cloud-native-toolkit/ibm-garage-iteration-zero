provider "null" {
}
provider "local" {
}

locals {
  namespaces        = ["${var.tools_namespace}", "${var.dev_namespace}", "${var.test_namespace}", "${var.staging_namespace}"]
  tools_ns_file     = "${path.cwd}/.tmp/tools_namespace.val"
  dev_ns_file       = "${path.cwd}/.tmp/dev_namespace.val"
  test_ns_file      = "${path.cwd}/.tmp/test_namespace.val"
  staging_ns_file   = "${path.cwd}/.tmp/prod_namespace.val"
  namespace_files   = ["${local.tools_ns_file}", "${local.dev_ns_file}", "${local.test_ns_file}", "${local.staging_ns_file}"]
}

resource "null_resource" "delete_namespaces" {
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/deleteNamespace.sh ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "create_namespaces" {
  depends_on = ["null_resource.delete_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/createNamespace.sh ${local.namespaces[count.index]} && echo -n ${local.namespaces[count.index]} > ${local.namespace_files[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/deleteNamespace.sh ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "create_cluster_pull_secret_iks" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/cluster-pull-secret-apply.sh ${var.cluster_name}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "copy_tls_secrets" {
  depends_on = ["null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-secret-to-namespace.sh ${var.cluster_name} ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "copy_apikey_secret" {
  depends_on = ["null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-secret-to-namespace.sh ibmcloud-apikey ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "create_pull_secrets" {
  depends_on = ["null_resource.create_cluster_pull_secret_iks", "null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-namespace-pull-secrets.sh ${var.cluster_name} ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "copy_cloud_configmap" {
  depends_on = ["null_resource.create_namespaces"]
  count      = "${length(local.namespaces)}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-configmap-to-namespace.sh ibmcloud-config ${local.namespaces[count.index]}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

data "local_file" "tools_namespace" {
  depends_on = ["null_resource.create_namespaces", "null_resource.copy_apikey_secret", "null_resource.copy_cloud_configmap"]

  filename = "${local.tools_ns_file}"
}

data "local_file" "dev_namespace" {
  depends_on = ["null_resource.create_namespaces"]

  filename = "${local.dev_ns_file}"
}

data "local_file" "test_namespace" {
  depends_on = ["null_resource.create_namespaces"]

  filename = "${local.test_ns_file}"
}

data "local_file" "staging_namespace" {
  depends_on = ["null_resource.create_namespaces"]

  filename = "${local.staging_ns_file}"
}
