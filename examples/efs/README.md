# terraform-efs-module

You can provision your own EFS stack .

## Supported Resources : 
* EFS 

You can check the efs module from <a href="/main.tf"></a> . That is the simple usage of efs module .


```terraform
module "efs" {
    source = "git::https://github.com/kloia/terraform-modules//efs"
    vpc_id = "vpc-AAAAA"
    subnets = ["subnet-123","subnet-1234"]
}
```