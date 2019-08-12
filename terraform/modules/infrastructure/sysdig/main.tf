data "ibm_resource_group" "tools_resource_group" {
  name = "${var.resource_group_name}"
}

// SysDig - Monitoring
resource "ibm_resource_instance" "sysdig_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-sysdig"
  service           = "sysdig-monitor"
  plan              = "graduated-tier"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.tools_resource_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_key" "sysdig_instance_key" {
  name                  = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-sysdig-key"
  resource_instance_id = "${ibm_resource_instance.sysdig_instance.id}"
  role = "Manager"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

locals {
  access_key="${ibm_resource_key.sysdig_instance_key.credentials["Sysdig Access Key"]}"
  endpoint="${ibm_resource_key.sysdig_instance_key.credentials["Sysdig Collector Endpoint"]}"
}

resource "null_resource" "create_sysdig_agent" {
  depends_on = ["ibm_resource_key.sysdig_instance_key"]

  provisioner "local-exec" {
    command = "${path.module}/scripts/bind-sysdig.sh ${local.access_key} ${local.endpoint}"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${path.module}/scripts/unbind-sysdig.sh"

    environment = {
      KUBECONFIG_IKS = "${var.cluster_type != "openshift" ? var.cluster_config_file_path : ""}"
    }
  }
}
