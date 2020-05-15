# terraform-elasticache-module

You can provision your own Redis based elasticache cluster . That module containing all resources what you need for
network stack on AWS . 

## Supported Resources : 
* Elasticache Replication Group
* Security Groups
* MaintainceWindow/Snapshot Parameters

You can check the terraofmr module from <a href="/main.tf"></a> , but you can customize your elasticache stack with this modules at below.


``` terraform
module "elasticache" {
    source = "git::https://github.com/kloia/terraform-modules.git//elasticache"

  tag_environment     = "staging"
  tag_project         = "webservices"
  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  vpc_id              = "vpc-ID"
  private_subnet_list = ["subnet-ID", "subnet-ID", "subnet-ID"]
  node_type           = "cache.t2.small"

}
```