

module "my_sqs" {
    source = "git::https://github.com/kloia/terraform-modules//sqs-direct"
    queue_names = ["q1", "q2", "q3"]
    tag_name = "tag"
    tag_deployment ="deployment"
    tag_kubernetes_cluster = "k8s"
    tag_organisation =  "org"
    tag_project = "project"
    tag_deployment_code = "deployment"
    
}

