variable "enabled" {
  default     = "true"
  description = "Set to false to prevent the module from creating or accessing any resources"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `a` or `b`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `{\"BusinessUnit\" = \"XYZ\"`)"
}

variable "auto_accept" {
  default     = "true"
  description = "Automatically accept the peering"
}
