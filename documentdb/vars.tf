variable "tag_organisation" {
  
}

variable "master_username" {
  
}


variable "master_password" {
  
}

variable "tag_project" {
  default = ""
}

# Cluster
variable "cluster_name" {
  
}

variable "instance_class" {
  default = "db.r4.large"
}

variable "instance_count" {
  default = 1
}

variable "port" {
  default = 27017
}


variable "backup_retention_period" {
  default = 1
}

variable "skip_final_snapshot" {
  default = false
}

variable "apply_immediately" {
  default = true
}

# VPC
variable "vpc_id" {
  
}

variable "vpc_azs" {
  type = "list"
}

variable "vpc_private_subnets_ids" {
  type = "list"
}

variable "vpc_private_subnet_cidrs" {
  type = "list"
}

variable "final_snapshot_identifier" {
  
}

variable "cluster_count" {
  default = 1
}

variable "custom_cidr_block" {
  type = "list"
  default = []
}
