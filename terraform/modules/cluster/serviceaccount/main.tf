provider "null" {
}
provider "local" {
}

locals {
  tmp_dir   = "${path.cwd}/.tmp"
  name_file = "${local.tmp_dir}/${var.service_account_name}.out"
}

resource "null_resource" "delete_serviceaccount" {

  provisioner "local-exec" {
    command = "${path.module}/scripts/delete-serviceaccount.sh ${var.namespace} ${var.service_account_name}"

    environment {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "create_serviceaccount" {
  depends_on = ["null_resource.delete_serviceaccount"]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-serviceaccount.sh ${var.namespace} ${var.service_account_name}"

    environment {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/delete-serviceaccount.sh ${var.namespace} ${var.service_account_name}"

    environment {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "add_ssc_openshift" {
  depends_on = ["null_resource.create_serviceaccount"]
  count = "${var.cluster_type == "openshift" ? length(var.sscs) : "0"}"

  provisioner "local-exec" {
    command = "oc adm policy add-scc-to-user ${var.sscs[count.index]} -n ${var.namespace} -z ${var.service_account_name}"
  }
}
