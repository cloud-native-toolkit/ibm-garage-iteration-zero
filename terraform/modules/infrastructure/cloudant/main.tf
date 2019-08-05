data "ibm_resource_group" "tools_resource_group" {
  name = "${var.resource_group_name}"
}

resource "ibm_resource_instance" "cloudant_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-cloudant"
  service           = "cloudantnosqldb"
  plan              = "lite"
  location          = "${var.resource_location}"
  resource_group_id = "${data.ibm_resource_group.tools_resource_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

locals {
  namespaces      = ["${var.dev_namespace}", "${var.test_namespace}", "${var.staging_namespace}"]
  namespace_count = 3
}

resource "ibm_container_bind_service" "cloudant_binding" {
  depends_on = ["ibm_resource_instance.cloudant_instance"]
  count = "${local.namespace_count}"

  cluster_name_id             = "${var.cluster_id}"
  service_instance_name       = "${ibm_resource_instance.cloudant_instance.name}"
  namespace_id                = "${local.namespaces[count.index]}"
  region                      = "${var.resource_location}"
  resource_group_id           = "${data.ibm_resource_group.tools_resource_group.id}"
  role                        = "Manager"

  // The provider (v16.1) is incorrectly registering that these values change each time,
  // this may be removed in the future if this is fixed.
  lifecycle {
    ignore_changes = ["id", "namespace_id", "service_instance_name"]
  }
}
