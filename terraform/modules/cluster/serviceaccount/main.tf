provider "null" {
}
provider "local" {
}

locals {
  tmp_dir   = "${path.cwd}/.tmp"
  name_file = "${local.tmp_dir}/${var.service_account_name}.out"
}

resource "null_resource" "write_service_account_name" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.tmp_dir} && echo -n ${var.service_account_name} > ${local.name_file}"
  }
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
      URL   = "${var.server_url}"
      TOKEN = "${var.ibmcloud_api_key}"
    }
  }
}

resource "null_resource" "delete_serviceaccount" {
  depends_on = ["null_resource.oc_login"]

  provisioner "local-exec" {
    command = "${path.module}/scripts/delete-serviceaccount.sh ${var.namespace} ${var.service_account_name}"

    environment {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}

resource "null_resource" "create_serviceaccount" {
  depends_on = ["null_resource.oc_login", "null_resource.delete_serviceaccount"]

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
    command = "oc adm policy add-scc-to-user ${var.sscs[count.index]} -z ${var.service_account_name}"
  }
}

data "local_file" "service_account_name" {
  depends_on = ["null_resource.write_service_account_name", "null_resource.add_ssc_openshift"]

  filename = "${local.name_file}"
}
