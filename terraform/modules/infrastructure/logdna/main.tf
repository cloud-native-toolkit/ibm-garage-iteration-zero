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
    command = "oc login -u apikey -p $${TOKEN} --server=$${URL} > /dev/null"

    environment = {
      URL   = "${var.server_url}"
      TOKEN = "${var.ibmcloud_api_key}"
    }
  }
}

resource "null_resource" "logdna_secret_openshift" {
  depends_on = ["null_resource.oc_login"]
  count      = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl create secret generic logdna-agent-key -n $${NAMESPACE} --from-literal=logdna-agent-key=${ibm_resource_key.logdna_instance_key.credentials.ingestion_key}"

    environment = {
      NAMESPACE = "default"
    }
  }
}

resource "null_resource" "logdna_secret_iks" {
  count = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl create secret generic logdna-agent-key -n $${NAMESPACE} --from-literal=logdna-agent-key=${ibm_resource_key.logdna_instance_key.credentials.ingestion_key}"

    environment = {
      KUBECONFIG = "${var.cluster_config_file_path}"
      NAMESPACE  = "default"
    }
  }
}

resource "null_resource" "logdna_agent_openshift" {
  depends_on = ["null_resource.logdna_secret_openshift"]
  count      = "${var.cluster_type == "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl create -n $${NAMESPACE} -f https://assets.us-south.logging.cloud.ibm.com/clients/logdna-agent-ds.yaml"

    environment = {
      NAMESPACE = "default"
    }
  }
}

resource "null_resource" "logdna_agent_iks" {
  depends_on = ["null_resource.logdna_secret_iks"]
  count      = "${var.cluster_type != "openshift" ? "1" : "0"}"

  provisioner "local-exec" {
    command = "kubectl create -n $${NAMESPACE} -f https://assets.us-south.logging.cloud.ibm.com/clients/logdna-agent-ds.yaml"

    environment = {
      KUBECONFIG = "${var.cluster_config_file_path}"
      NAMESPACE  = "default"
    }
  }
}

/*
TBD: Requires John Martins help to automate the creation of secrets and performan a kube deploy
provider "kubernetes" {
  config_path = "${data.ibm_container_cluster_config.cluster.config_file_path}"
}
// Create Secret in 
resource "kubernetes_secret" "logdna_secret" {
  metadata {
    name = "logdna-agent-key"
    namspace = "default"
  }

  data = {
    logdna-agent-key = "${ibm_service_key.logdna_instance_key.id}"
  }

  type = "Opaque"
}

// kubectl create -f https://assets.us-south.logging.cloud.ibm.com/clients/logdna-agent-ds.yaml
# Deployment
resource "kubernetes_deployment" "logdna_instance_agent" {
  metadata {
    name      = "logdna-agent"
    namespace = "default"
    self_link = "https://assets.us-south.logging.cloud.ibm.com/clients/logdna-agent-ds.yaml"
  }
}
*/
