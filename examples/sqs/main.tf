

module "my_sqs" {
    source = "../../sqs"
    queue_names = ["q1", "q2", "q3"]
    tag_name = "tag"
    tag_deployment ="deployment"
    tag_kubernetes_cluster = "k8s"
    tag_organisation =  "org"
    tag_project = "project"
    tag_deployment_code = "deployment"
    aws_region = ""
    aws_accountId = ""
    
}

