# terraform-elasticsearch-module

You can provision your own ElasticSearch stack .

## Supported Resources : 
* Managed Elastic Search

You can check the elascticsearch module from <a href="/main.tf"></a> . 

Notice : Usage of the ElastiCache module .

### Usage of the ElastiCache module : 
You can define instance_type, snapshot period , ebs related configs and etc .. 
That is the usage at below . 

```terraform
    module "elasticache" {
        source = "../../elasticsearch/"
        instance_type = "t2.micro.elasticsearch"
        snapshot_hours_period = 23
    }
```