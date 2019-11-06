variable "env_tag" {
  default = "SqsEndpoint"
}
variable "vpc_id" {
  
}

variable "service_name" {
  default = "com.amazonaws.us-east-1.sqs"
}

variable "endpoint_type" {
  default = "Interface"
}

variable "private_dns_enabled" {
  default= false
}

variable "subnet_ids" {
  type = "list"
}

variable "name" {
  
}

variable "security_group_ids" {
  
}
