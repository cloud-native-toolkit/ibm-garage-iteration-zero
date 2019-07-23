data "ibm_resource_group" "tools_resource_group" {
  name = "${var.resource_group_name}"
}

// COS Cloud Object Storage
resource "ibm_resource_instance" "cos_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-cloud-object-storage"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = "${data.ibm_resource_group.tools_resource_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_container_bind_service" "cos_binding_dev" {
  cluster_name_id             = "${var.cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cos_instance.name}"
  namespace_id                = "${var.dev_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resource_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}

resource "ibm_container_bind_service" "cos_binding_test" {
  cluster_name_id             = "${var.cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cos_instance.name}"
  namespace_id                = "${var.test_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resource_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}

resource "ibm_container_bind_service" "cos_binding_staging" {
  cluster_name_id             = "${var.cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cos_instance.name}"
  namespace_id                = "${var.staging_namespace}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resource_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}
