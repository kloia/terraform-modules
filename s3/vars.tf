variable "name" {
  
}

variable "acl" {
    default = "private"
}

variable "tag_name" {
  
}

variable "tag_env" {
  
}


variable "force_destroy" {
  default = false
}


variable "versioning" {
    default = true
}




variable "is_enabled" {
  default = false
}


variable "prefix" {
  description = "(Optional) Key prefix. Used to manage object lifecycle events."
  default     = ""
}



variable "storage_class" {
  default = "STANDARD_IA"
}

variable "long_storage_class" {
  default = "GLACIER"
}

variable "short_storage_day" {
  default     = 30
}

variable "long_storage_day" {
    default     = 60

}

variable "expiration" {
    default     = 90

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
