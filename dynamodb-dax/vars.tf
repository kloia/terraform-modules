variable "dax_cluster_name" {
  default = "cluster-1"
}

variable "dax_subnet_lists" {
  type = "list"
  default = ["subnet-1", "subnet-2"]
}

variable "query_ttl_millis" {
  default = "100000"
}

variable "record_ttl_millis" {
  default = "100000"
}

variable "replication_factor" {
  default = 1
}

variable "instance_type" {
  default = "dax.r4.large"
}


variable "encryption_enabled" {
  default = true
}
