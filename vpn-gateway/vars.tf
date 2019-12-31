variable "vpc_id" {
  default = "vpc-09c78cc7ee5354f36"
}

variable "tag_name" {
  default = "MyGW"
}

variable "custom_asn" {
    
}

variable "ip_address" {
  
}

variable "type" {
  default = "ipsec.1"
}


variable "bgp_asn" {
  default = 65000
}

variable "organization" {
  default = "myorg"
}


variable "route_type" {
  
  default = true
}
