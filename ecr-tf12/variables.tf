variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags (e.g. `map('Environment','Dev')`)"
  type        = map(string)
  default     = {}
}

variable "principals_full_access" {
  description = "Principal ARNs to provide with full access to the ECR"
  type        = list(string)
  default     = []
}

variable "principals_readonly_access" {
  description = "Principal ARNs to provide with readonly access to the ECR"
  type        = list(string)
  default     = []
}

variable "scan_images_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "repo_names" {
  description = "List repository names for AWS ECR"
  type        = list(string)
  default     = []
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"
  type        = string
  default     = "MUTABLE"
}


variable "ecr_lifecycle_policies" {
  description = "Map of ECR lifecycle policies"
  type        = map
  default     = {}
}
