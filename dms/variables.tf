variable "allocated_storage" {
  default = 20
}

variable "apply_immediately" {
  default = true
}



variable "minor_version_upgrade" {
  default = true
}

variable "engine_version" {
  default = "3.1.4"
}

variable "is_multi_az" {
  default = true
}

variable "maintaince_window" {
  default = "sun:10:30-sun:14:30"
}


variable "publicly_accessible" {
  default = true
}

variable "instance_class" {
  default = "dms.t2.micro"
}

variable "instance_id" {
  default = "dynamodbmigrator"
}

variable "deletion_window" {
  default = 10
}

variable "use_default_kms" {
  default = true
}

variable "tags" {
  type = "map"
  default = {
    "Project" = "KloiaDataTeam"
  }
}

variable "security_groups" {
  default = ["sg-123", "sg-124"]
}

variable "subnet_ids" {
  default = ["subnet-123", "subnet-124"]
}

variable "mongodb_cert_arn" {
  default = ""
}

variable "mongodb_port" {
  default = 27017
}
variable "mongodb_server_name" {
  default = ""
}

variable "mongodb_database_name" {
  default = "mydatabase"
}

variable "mongodb_endpoint_id" {
  default = "mongodbconnendpoint"
}

variable "extra_conn_attr_mongodb" {
  default = ""
}

variable "extra_conn_attr_dynamodb" {
  default = ""
}

variable "username" {
  default = ""
}
variable "password" {
  default = ""
}

variable "ssl_mode" {
  default = "none"
}

variable "dynamodb_target_name" {
  default = "dynamodbtarget"
}

variable "migration_type" {
  default = "full-load"
}

variable "map_rule_path" {
  default = ""
}

variable "replication_task_id" {
  
}

variable "repl_task_path" {
  
}

variable "extract_doc_id" {
  default = true
}
