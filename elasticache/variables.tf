variable "engine" {
  default = "redis"
}

variable "node_type" {
  default = "cache.m4.large"
}

variable "num_node_groups" {
  default = 2
}

variable "port" {
  default = "6379"
}

variable "cluster_name" {
  default = "elasticache-cluster"
}


variable "redis_version" {
  default = "redis2.8"
}


variable "private_subnet_list" {
  type = "list"
}
variable "redis_parameter_family" {
  default = "redis5.0"
}

variable "tag_environment" {
  
}
variable "tag_project" {
  
}

variable "custom_cidr_block" {
  type = "list"
  default = ["10.0.0.0/16"]
}

variable "automatic_failover" {
  default = true
}


variable "vpc_id" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}


variable "snapshot_retention_limit" {
  default = 0
}

variable "maintenance_window" {
  default = "sun:03:00-sun:04:00"
}

variable "snapshot_window" {
  default = "06:30-07:30"
}

variable "transit_encrypt" {
  default = "true"
  type    = "string"
}

variable "at_rest_encrypt" {
  default = "true"
  type    = "string"

}

variable "cache_cluster" {
  default = 1
}


variable "replica_node_count" {
  default = 3
}

variable "node_group_count" {
  default =1 
}
