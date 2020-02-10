
variable "scan_on_push" {
  default = false
}

variable "tag_mutability" {
    default = "MUTABLE"
}

variable "repo_policy" {
  
}


variable "repo_names" {
  type = "list"
}