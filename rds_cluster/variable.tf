variable "tag_project" {
  
}

variable "vpc_security_group_id" {
  
}

variable "engine_version" {
  default = ""
}

variable "engine" {
  
}

variable "engine_mode" {
  
}

variable "database_name" {
  
}

variable "master_user" {
  
}

variable "master_password" {
  
}


variable "encrypted" {
    default = true
}

variable "rds_subnet_group_id" {
  
}

variable "auto_pause" {
  default = true
}

variable "timeout_action" {
  default = "ForceApplyCapacityChange"
}

variable "seconds_until_auto_pause" {
  default = 300
}

variable "min_capacity" {
  
}

variable "max_capacity" {
  
}


variable "skip_final_snapshot" {
  default = false
}

variable "apply_immediately" {
  default = true
}

variable "backup_ret_period" {
  default = 5
}


variable "final_snapshot_identifier" {
  default = ""
}


variable "backup_window" {
  default = "03:00-07:00"
}

variable "organization" {
  
}

variable "is_data_api_enabled" {
  default = true
}

variable "parameter_group" {
  
}

variable "db_identifier" {

}

variable "maintenance_window" {
  default = "Mon:03:00-Mon:04:00"
}

variable "copy_tags_snapshot" {
  default = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = "string"
  default     = ""
}