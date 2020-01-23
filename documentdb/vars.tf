# Tags
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

variable "master_username" {
  
}

variable "backup_retention_period" {
  default = 1
}

variable "skip_final_snapshot" {
  default = true
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

variable "vpc_public_subnet_cidrs" {
  type = "list"
}