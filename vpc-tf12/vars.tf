
variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
    default = true
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

variable "tag_name" {
  default = ""
}


variable "tag_deployment" {
    default = ""

}

variable "tag_kubernetes_cluster" {
  default = ""

}

variable "tag_organisation" {
    default = ""

}

variable "tag_project" {
    default = ""

}


variable "tag_deployment_code" {
    default = ""

}

variable "cluster_name" {
  
}


variable "tags" {
  type        = "map"
  default     = {}
  description = "Map of tags to be applied to all resources"
}
