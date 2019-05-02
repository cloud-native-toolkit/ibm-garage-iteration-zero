data "ibm_resource_group" "iks_resource_group" {
  name = "iks-tf-test"
}

data "ibm_resource_instance" "postgresql_instance" {
  name              = "iks-tf-test-postgres"
  service           = "databases-for-postgresql"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
}

resource "ibm_resource_key" "postgresql_credentials" {
  name                 = "${data.ibm_resource_group.iks_resource_group.name}-postgresql-key"
  role                 = "Administrator"
  resource_instance_id = "${data.ibm_resource_instance.postgresql_instance.id}"
}

resource "helm_release" "sonarqube_release" {
  name       = "sonarqube"
  chart      = "./charts/ibm-sonarqube"
  namespace  = "tools"
  timeout    = 1200

  values = [
    "${file("sonarqube-values.yaml")}"
  ]

  set {
    name = "ingress.hosts.0"
    value = "${var.sonarqube_ingress_host}"
  }

  set_string {
    name = "database.hostname"
    value = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.hosts.0.hostname}"
  }

  set_string {
    name = "database.port"
    value = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.hosts.0.port}"
  }

  set_string {
    name = "database.name"
    value = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.database}"
  }

  set_string {
    name = "database.username"
    value = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.authentication.username}"
  }

  set_string {
    name = "database.password"
    value = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.authentication.password}"
  }
}
