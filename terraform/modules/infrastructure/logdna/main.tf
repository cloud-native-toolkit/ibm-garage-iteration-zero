provider "ibm" {
}

data "ibm_resource_group" "tools_resource_group" {
  name = "${var.resource_group_name}"
}

// LogDNA - Logging
resource "ibm_resource_instance" "logdna_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-logdna"
  service           = "logdna"
  plan              = "7-day"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.tools_resource_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_key" "logdna_instance_key" {
  name                 = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-logdna-key"
  resource_instance_id = "${ibm_resource_instance.logdna_instance.id}"
  role                 = "Manager"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "null_resource" "oc_login" {
  count = "${var.cluster_type == "openshift" ? "1": "0"}"

  provisioner "local-exec" {
    command = "oc login -u apikey -p ${var.ibmcloud_api_key} --server=${var.server_url} > /dev/null"
  }
}

locals {
  namespace = "default"
}

resource "null_resource" "logdna_bind" {
  depends_on = ["null_resource.oc_login"]

  provisioner "local-exec" {
    command = "${path.module}/scripts/bind-logdna.sh ${local.namespace} ${ibm_resource_key.logdna_instance_key.credentials.ingestion_key} ${var.service_account_name}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
      TMP_DIR        = "${path.cwd}/.tmp"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/unbind-logdna.sh ${local.namespace}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}
