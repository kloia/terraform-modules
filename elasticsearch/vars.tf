variable "domain_name" {
  
}

variable "vpc_id" {
  
}
variable "private_subnets" {
  type= "list"
}

variable "ebs_volume_size" {
  
}

variable "ebs_volume_type" {
  
}

variable "elastic_search_zone_id" {
  default = ""
}


variable "elasticsearch_version" {
  
}
variable "dedicated_master_type" {
  default = false
}

variable "instance_type" {
  
}
variable "instance_count" {
  default = 1
}


variable "es_zone_awareness" {
  default = false
}

variable "snapshot_hours_period" {
  
}
variable "ebs_enabled" {
  default = true
}

variable "ingress_allow_cidr_blocks" {
  default     = ["10.10.0.0/16"]
  description = "Specifies the ingress CIDR blocks allowed."
  type        = "list"
}

