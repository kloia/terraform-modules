output "global"  {
  
    value =  {
      Name = "${var.tag_name}"
      Deployment        = "${var.tag_deployment}"
      DeploymentCode  = "${var.tag_deployment_code}"
      KubernetesCluster = "${var.tag_kubernetes_cluster}"
      Organisation      = "${var.tag_organisation}"
      Project           = "${var.tag_project}"

    }
}