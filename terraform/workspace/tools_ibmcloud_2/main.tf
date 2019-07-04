data "ibm_resource_group" "tools_resouce_group" {
  name = "${var.resource_group_name}"
}

// LogDNA - Logging
resource "ibm_resource_instance" "logdna_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resouce_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-logdna"
  service           = "logdna"
  plan              = "7-day"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.tools_resouce_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_key" "logdna_instance_key" {
  name                  = "${replace(data.ibm_resource_group.tools_resouce_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-logdna-key"
  resource_instance_id = "${ibm_resource_instance.logdna_instance.id}"
  role = "Manager"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

/*
TBD: Requires John Martins help to automate the creation of secrets and performan a kube deploy
provider "kubernetes" {
  config_path = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
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


// SysDig - Monitoring
resource "ibm_resource_instance" "sysdig_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resouce_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-sysdig"
  service           = "sysdig-monitor"
  plan              = "graduated-tier"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.tools_resouce_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_key" "sysdig_instance_key" {
  name                  = "${replace(data.ibm_resource_group.tools_resouce_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-sysdig-key"
  resource_instance_id = "${ibm_resource_instance.sysdig_instance.id}"
  role = "Manager"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

// AppID - App Authentication
resource "ibm_resource_instance" "appid_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resouce_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-appid"
  service           = "appid"
  plan              = "graduated-tier"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.tools_resouce_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_container_bind_service" "appid_service_binding_prod" {
  cluster_name_id             = "${var.iks_cluster_id}"
  service_instance_name       = "${ibm_resource_instance.appid_instance.name}"
  namespace_id                = "${var.prod_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resouce_group.id}"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}

resource "ibm_container_bind_service" "appid_service_binding_dev" {
  cluster_name_id             = "${var.iks_cluster_id}"
  service_instance_name       = "${ibm_resource_instance.appid_instance.name}"
  namespace_id                = "${var.dev_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resouce_group.id}"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}

// COS Cloud Object Storage
resource "ibm_resource_instance" "cos_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resouce_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-cloud-object-storage"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = "${data.ibm_resource_group.tools_resouce_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_container_bind_service" "cos_binding_dev" {
  cluster_name_id             = "${var.iks_cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cos_instance.name}"
  namespace_id                = "${var.dev_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resouce_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}

resource "ibm_container_bind_service" "cos_binding_prod" {
  cluster_name_id             = "${var.iks_cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cos_instance.name}"
  namespace_id                = "${var.prod_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resouce_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}

resource "ibm_resource_instance" "cloudant_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resouce_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-cloudant"
  service           = "cloudantnosqldb"
  plan              = "lite"
  location          = "${var.resource_location}"
  resource_group_id = "${data.ibm_resource_group.tools_resouce_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_container_bind_service" "cloudant_binding_dev" {
  cluster_name_id             = "${var.iks_cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cloudant_instance.name}"
  namespace_id                = "${var.dev_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resouce_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}

resource "ibm_container_bind_service" "cloudant_binding_prod" {
  cluster_name_id             = "${var.iks_cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cloudant_instance.name}"
  namespace_id                = "${var.prod_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resouce_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}
