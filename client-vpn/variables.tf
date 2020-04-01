variable "client_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_list" {
  type        = "list"
  description = "Subnet Assosication with the Client VPN endpoint."
  default     = ["subnet-123", "subnet-124", "subnet-125"]
}

variable "tag_name" {
  default = "test"
}

variable "aws_region" {
  default = "eu-north-1"
}

variable "dns_servers" {
  default = ["8.8.8.8"]
  type    = "list"
}

variable "tag_environment" {
  default = "prod"
}

variable "is_split_tunnel" {
  default = true
}

variable "auth_type" {
  default = "certificate-authentication"
}


variable "enable_logs" {
  default = true
}