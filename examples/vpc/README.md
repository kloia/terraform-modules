# terraform-vpc-module

You can provision your own vpc stack . That module containing all resources what you need for
network stack on AWS . 

## Supported Resources : 
* VPC
* Subnet ( Public/Private; by default it creating 3 piece of subnet each one )
* NAT Gateway
* Internet Gateway
* Route Tables
* Routes

You can check the vpc module from <a href="/main.tf"></a> , but you can customize your vpc stack with this modules shown at below .


``` terraform
module "vpc" {
  source = "git::https://github.com/kloia/terraform-modules.git//vpc?ref=v0.0.1"
  
  private_subnet_count = 2
  public_subnet_count = 1
  vpc_cidr = "172.31.0.0/16"
  tag_organisation = "${var.tag_organisation}"
  tag_deployment ="${var.tag_deployment}"
  tag_deployment_code = "${var.tag_deployment_code}"
  tag_kubernetes_cluster = "${var.tag_kubernetes_cluster}"
  tag_project = "${var.tag_project}"
}
```