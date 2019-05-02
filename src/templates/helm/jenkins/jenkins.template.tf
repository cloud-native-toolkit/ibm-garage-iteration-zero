data "helm_repository" "incubator" {
    name = "incubator"
    url  = "https://kubernetes-charts-incubator.storage.googleapis.com/"
}

resource "helm_release" "jenkins_release" {
  name       = "jenkins"
  repository = "${data.helm_repository.incubator.metadata.0.name}"
  chart      = "stable/jenkins"
  namespace  = "tools"
  timeout    = 1200

  values = [
    "${file("jenkins-values.yaml")}"
  ]

  set {
    name = "Master.ingress.hostName"
    value = "jenkins.iks-tf-testcluster.us-south.containers.appdomain.cloud"
  }
}
