# terraform-sqs-direct-module

You can provision your own sqs stack . SQS-Direct module is creating sqs queues without dead-letter-queue option

## Supported Resources : 
* SQS queue

You can check the sqs-direct module from <a href="/main.tf"></a> . That is the simple usage of sqs module .

Notice : This module is importing global-value and mapping modules on itself for generate the sqs queue config values . 


```terraform
module "my_sqs" {
    source = "git::https://github.com/kloia/terraform-modules//sqs-direct"
    queue_names = ["queue-name-1", "queue-name-2", "queue-name-3"]
    tag_name = "tag"
    tag_deployment ="deployment"
    tag_kubernetes_cluster = "k8s"
    tag_organisation =  "org"
    tag_project = "project"
    tag_deployment_code = "deployment"
}
```