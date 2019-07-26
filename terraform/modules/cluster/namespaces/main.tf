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

resource "null_resource" "wait_for_cluster" {
  provisioner "local-exec" {
    command = "echo \"Cluster type: ${var.cluster_type}\""
  }
}

resource "null_resource" "oc_login" {
  depends_on = ["null_resource.wait_for_cluster"]
  count = "${var.cluster_type == "openshift" ? "1": "0"}"

  provisioner "local-exec" {
    command = "oc login -u apikey -p $${TOKEN} --server=$${URL} > /dev/null"

    environment = {
      URL="${var.server_url}"
      TOKEN="${var.ibmcloud_api_key}"
    }
  }
}

resource "null_resource" "delete_namespaces_openshift" {
  depends_on = ["null_resource.wait_for_cluster", "null_resource.oc_login"]
  count      = "${var.cluster_type == "openshift" ? length(local.namespaces) : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/deleteNamespace.sh $${NAMESPACE}"

    environment = {
      NAMESPACE  = "${local.namespaces[count.index]}"
    }
  }
}

resource "null_resource" "delete_namespaces_iks" {
  depends_on = ["null_resource.wait_for_cluster"]
  count      = "${var.cluster_type != "openshift" ? length(local.namespaces) : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/deleteNamespace.sh $${NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file_path}"
      NAMESPACE  = "${local.namespaces[count.index]}"
    }
  }
}

resource "null_resource" "create_namespace_openshift" {
  depends_on = ["null_resource.oc_login", "null_resource.delete_namespaces_openshift"]
  count      = "${var.cluster_type == "openshift" ? length(local.namespaces) : "0"}"

  provisioner "local-exec" {
    command = "echo \"creating namespace $${NAMESPACE}\"; oc new-project $${NAMESPACE} > /dev/null && echo -n $${NAMESPACE} > $${FILE}"

    environment = {
      NAMESPACE = "${local.namespaces[count.index]}"
      FILE      = "${local.namespace_files[count.index]}"
    }
  }
}

resource "null_resource" "create_namespace_iks" {
  depends_on = ["null_resource.delete_namespaces_iks"]
  count      = "${var.cluster_type != "openshift" ? length(local.namespaces) : 0}"

  provisioner "local-exec" {
    command = "echo \"creating namespace $${NAMESPACE}\"; kubectl create namespace $${NAMESPACE} && echo -n $${NAMESPACE} > $${FILE}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file_path}"
      NAMESPACE  = "${local.namespaces[count.index]}"
      FILE      = "${local.namespace_files[count.index]}"
    }
  }
}

resource "null_resource" "create_cluster_pull_secret_iks" {
  depends_on = ["null_resource.wait_for_cluster"]
  count      = "${var.cluster_type != "openshift" ? 1 : 0}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/cluster-pull-secret-apply.sh ${var.cluster_name}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file_path}"
      CLUSTER_NAME = "${var.cluster_name}"
    }
  }
}

resource "null_resource" "copy_tls_secrets_iks" {
  depends_on = ["null_resource.create_namespace_iks"]
  count      = "${var.cluster_type != "openshift" ? length(local.namespaces) : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-secret-to-namespace.sh ${var.cluster_name} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file_path}"
      CLUSTER_NAMESPACE = "${local.namespaces[count.index]}"
    }
  }
}

resource "null_resource" "create_pull_secrets_iks" {
  depends_on = ["null_resource.create_cluster_pull_secret_iks", "null_resource.create_namespace_iks"]
  count      = "${var.cluster_type != "openshift" ? length(local.namespaces) : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-namespace-pull-secrets.sh ${var.cluster_name} $${CLUSTER_NAMESPACE}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file_path}"
      CLUSTER_NAMESPACE = "${local.namespaces[count.index]}"
    }
  }
}

resource "null_resource" "copy_tls_secrets_openshift" {
  depends_on = ["null_resource.oc_login", "null_resource.create_namespace_openshift"]
  count      = "${var.cluster_type == "openshift" ? length(local.namespaces) : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/copy-secret-to-namespace.sh ${var.cluster_name} $${CLUSTER_NAMESPACE}"

    environment = {
      CLUSTER_NAMESPACE = "${local.namespaces[count.index]}"
    }
  }
}

resource "null_resource" "create_pull_secrets_openshift" {
  depends_on = ["null_resource.oc_login", "null_resource.create_namespace_openshift"]
  count      = "${var.cluster_type == "openshift" ? length(local.namespaces) : "0"}"

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-namespace-pull-secrets.sh ${var.cluster_name} $${CLUSTER_NAMESPACE}"

    environment = {
      CLUSTER_NAMESPACE = "${local.namespaces[count.index]}"
    }
  }
}

data "local_file" "tools_namespace" {
  depends_on = ["null_resource.create_namespace_openshift", "null_resource.create_namespace_iks"]

  filename = "${local.tools_ns_file}"
}

data "local_file" "dev_namespace" {
  depends_on = ["null_resource.create_namespace_openshift", "null_resource.create_namespace_iks"]

  filename = "${local.dev_ns_file}"
}

data "local_file" "test_namespace" {
  depends_on = ["null_resource.create_namespace_openshift", "null_resource.create_namespace_iks"]

  filename = "${local.test_ns_file}"
}

data "local_file" "staging_namespace" {
  depends_on = ["null_resource.create_namespace_openshift", "null_resource.create_namespace_iks"]

  filename = "${local.staging_ns_file}"
}
