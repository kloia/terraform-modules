variable "client_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_list" {
  type = "list"
  description = "The ID of the subnet to associate with the Client VPN endpoint."
  default = [""]
}
variable "client" {
  default = "client1" 
}

variable "cert_dir" {
  default = "certs"
}

variable "domain" {
  default = "daas.kloia"
}
variable "tag_name" {
  default = "test"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "dns_servers" {
  default = ["8.8.8.8"]
  type = "list"
}

variable "tag_environment" {
  default = "prod"
}

variable "is_split_tunnel" {
  default = true
}

variable "is_access_internet" {
  default = true
}

variable "auth_type" {
  default = "certificate-authentication"
}
