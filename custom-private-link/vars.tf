variable "nlb_arns" {
  type = "list"
  default = ["arn:aws:elasticloadbalancing:eu-central-1::ACCOUNT_ID::LOADBALANCER_NAME"]
}

variable "acceptance_required" {
  default = true
}


variable "tag_environment" {
  default = "test"
}

variable "security_group_ids" {
  type = "list"
  default = ["sg-a123"]
}

variable "subnet_ids" {
  type = "list"
  default = ["subnet-123", "subnet-1234"]
}

variable "vpc_id" {
  default = "vpc-123131"
}


variable "customer_service" {
  default = "myservice"
}


variable "hosted_zone" {
  default = "internal.k8s"
}


variable "service_dns_prefix" {
  default = "nlb"
}




