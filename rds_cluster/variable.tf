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



variable "profile" {
  
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
