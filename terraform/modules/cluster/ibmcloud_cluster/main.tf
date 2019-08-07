provider "ibm" {
}
provider "null" {
}
provider "local" {
}

data "ibm_resource_group" "resource_group" {
  name = "${var.resource_group_name}"
}

resource "null_resource" "ibmcloud_login" {
  provisioner "local-exec" {
    command = "ibmcloud login -r $${REGION} -g $${RESOURCE_GROUP} --apikey $${APIKEY} > /dev/null"

    environment = {
      REGION         = "${var.cluster_region}"
      RESOURCE_GROUP = "${var.resource_group_name}"
      APIKEY         = "${var.ibmcloud_api_key}"
    }
  }
}

locals {
  server_url_file    = "${path.cwd}/.tmp/server-url.val"
  cluster_type_file  = "${path.cwd}/.tmp/cluster_type.val"
  ingress_url_file   = "${path.cwd}/.tmp/ingress-subdomain.val"
  kube_version_file  = "${path.cwd}/.tmp/kube_version.val"
  cluster_config_dir = "${var.kubeconfig_download_dir}/.kube"
  cluster_name       = "${var.cluster_name}"
}

resource "null_resource" "get_openshift_version" {
  depends_on = ["null_resource.ibmcloud_login"]
  count = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "ibmcloud ks versions --show-version ${var.cluster_type} | grep ${var.cluster_type} | xargs echo -n > ${local.kube_version_file}"
  }
}

resource "null_resource" "get_kubernetes_version" {
  depends_on = ["null_resource.ibmcloud_login"]
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "ibmcloud ks versions --show-version kubernetes | grep default | sed -E \"s/^(.*) [(]default[)].*/\\1/g\" | xargs echo -n > ${local.kube_version_file}"
  }
}

data "local_file" "latest_kube_version" {
  depends_on = ["null_resource.get_openshift_version", "null_resource.get_kubernetes_version"]

  filename = "${local.kube_version_file}"
}

resource "ibm_container_cluster" "create_cluster" {
  count             = "${var.cluster_exists != true ? "1" : "0"}"

  name              = "${local.cluster_name}"
  datacenter        = "${var.vlan_datacenter}"
  kube_version      = "${data.local_file.latest_kube_version.content}"
  machine_type      = "${var.cluster_machine_type}"
  hardware          = "${var.cluster_hardware}"
  default_pool_size = "${var.cluster_worker_count}"
  region            = "${var.cluster_region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  private_vlan_id   = "${var.private_vlan_id}"
  public_vlan_id    = "${var.public_vlan_id}"
}

resource "null_resource" "create_cluster_config_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.cluster_config_dir}"
  }
}

data "ibm_container_cluster_config" "cluster" {
  depends_on        = ["ibm_container_cluster.create_cluster", "null_resource.ibmcloud_login", "null_resource.create_cluster_config_dir"]

  cluster_name_id   = "${local.cluster_name}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  config_dir        = "${local.cluster_config_dir}"
  region            = "${var.cluster_region}"
}

resource "null_resource" "get_server_url" {
  depends_on = ["data.ibm_container_cluster_config.cluster", "null_resource.ibmcloud_login"]

  provisioner "local-exec" {
    command = "ibmcloud ks cluster-get --cluster $${CLUSTER_NAME} | grep \"Master URL\" | sed -E \"s/Master URL: +(.*)$/\\1/g\" | xargs echo -n > $${FILE}"

    environment = {
      CLUSTER_NAME = "${local.cluster_name}"
      FILE         = "${local.server_url_file}"
    }
  }
}

data "local_file" "server_url" {
  depends_on = ["null_resource.get_server_url"]

  filename = "${local.server_url_file}"
}

resource "null_resource" "get_ingress_subdomain" {
  depends_on = ["data.ibm_container_cluster_config.cluster", "null_resource.ibmcloud_login"]

  provisioner "local-exec" {
    command = "ibmcloud ks cluster-get --cluster $${CLUSTER_NAME} | grep \"Ingress Subdomain\" | sed -E \"s/Ingress Subdomain: +(.*)$/\\1/g\" | xargs echo -n > $${FILE}"

    environment = {
      CLUSTER_NAME = "${local.cluster_name}"
      FILE         = "${local.ingress_url_file}"
    }
  }
}

data "local_file" "ingress_subdomain" {
  depends_on = ["null_resource.get_ingress_subdomain"]

  filename = "${local.ingress_url_file}"
}

resource "null_resource" "get_cluster_type" {
  depends_on = ["data.ibm_container_cluster_config.cluster", "null_resource.ibmcloud_login"]

  provisioner "local-exec" {
    command = "if [[ -n $(ibmcloud ks cluster-get --cluster $${CLUSTER_NAME} | grep -E \"Version.*openshift\") ]]; then echo -n \"openshift\" > $${FILE}; else echo -n \"kubernetes\" > $${FILE}; fi"

    environment = {
      CLUSTER_NAME = "${local.cluster_name}"
      FILE         = "${local.cluster_type_file}"
    }
  }
}

data "local_file" "cluster_type" {
  depends_on = ["null_resource.get_cluster_type"]

  filename = "${local.cluster_type_file}"
}

resource "null_resource" "check_cluster_type" {
  provisioner "local-exec" {
    command = "if [[ \"$${PROVIDED_CLUSTER_TYPE}\" != \"$${ACTUAL_CLUSTER_TYPE}\" ]]; then echo \"Provided cluster type does not match the value from the server: $${ACTUAL_CLUSTER_TYPE}\"; exit 1; fi"

    environment = {
      PROVIDED_CLUSTER_TYPE = "${var.cluster_type}"
      ACTUAL_CLUSTER_TYPE   = "${data.local_file.cluster_type.content}"
    }
  }
}
