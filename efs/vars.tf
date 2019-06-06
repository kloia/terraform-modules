variable "encrypted" {
    default = true
}
variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`)"
}

variable "performance_mode" {
  type        = "string"
  default     = "generalPurpose"
  description = "maxIO / generalPurpose "
}

variable "provisioned_throughput_in_mibps" {
  default     = 0
   description = "Throughput per mibps"
}


variable "throughput_mode" {
  default     = "bursting"
  description = "Throughput mode for the file system. Defaults to bursting."
}

variable "security_groups" {
  default = []
  type = "list"
}

variable "description" {
  default = ""
}

variable "security_group_name" {
  default = "" 
}

variable "vpc_id" {
  
}

variable "subnets" {
  type = "list"
}


