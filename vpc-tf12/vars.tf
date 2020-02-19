
variable "enable_dns_support" {
  default = true
  type        = bool
}

variable "enable_dns_hostnames" {
    default = true
    type        = bool
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "vpc_id" {
    default = ""
}


variable "name" {
  description = "Resource Name subnet-vpc "
  default     = ""
}

variable "private_subnet_count" {
    default = 1 
}

variable "public_subnet_count" {
  default = 1 
}

variable "azs" {

  description = "Availability Zones"
  default     = []

}
variable "tags" {
  type = map
}
