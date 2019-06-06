variable "enabled" {
    default = "true"
}
variable "database_name" {
  
}

variable "port" {
  type = "map"

  default = {
    mysql = "3306"
    postgresql = "5432"
    mariadb = "3306"
  }
}

variable "storage_type" {
  
}

variable "subnet_group_name" {
  
}
variable "subnet_ids" {

    type = "list"
}

variable "database_user" {
  
}
variable "publicly_accessible" {
    default = "false"
}

variable "database_password" {  
    default = ""
}


variable "engine" {
  
}
variable "engine_version" {
  
}

variable "instance_class" {
  
}

variable "allocated_storage" {
  
}

variable "storage_encrypted" {
  
}
variable "vpc_id" {
  
}

variable "option_group_description" {
  
}


variable "options" {
  type        = "list"
  description = "Db Option Groups options for apply to the Database Instance"
  default     = []
}

variable "major_engine_version" {
  
}

variable "environment" {
  
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

