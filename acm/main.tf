resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.domain_name}"
  validation_method = "${var.validation_method}"


  tags {
    Name = "${var.tag_organisation}-certificate"
    Deployment        = "${var.tag_deployment}"
    DeploymentCode    = "${var.tag_deployment_code}"
    KubernetesCluster = "${var.tag_kubernetes_cluster}"
    Organisation      = "${var.tag_organisation}"
    Project           = "${var.tag_project}"
  }

}

output "cert_arn" {
  value = "${aws_acm_certificate.cert.id}"
}
