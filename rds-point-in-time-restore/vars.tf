variable "instance_type" {
  
}

variable "skip_last_snapshot" {
  default = true
}

variable "db_instance_identifier" {
  
}

variable "db_username" {
  
}

variable "db_password" {
  
}

variable "db_subnet_group_name" {
  
}

variable "security_groups" {
  type = "list"
}
variable "copy_tags_to_snapshot" {
  default = true
}

variable "backup_window" {
  
}

variable "backup_retention_period" {
  
}

variable "iops" {
  
}

variable "publicly_accessible" {
  
}

variable "allow_major_version_upgrade" {
  
}

variable "apply_immediately" {
  
}

variable "maintenance_window" {
  
}
variable "kms_key_id" {
  
}


variable "storage_encrypted" {
  
}
