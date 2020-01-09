variable "is_enabled" {
    default = true
}

variable "is_ipv6_enabled" {
    default = false
}
variable "domain_name" {
  
}

variable "origin_id" {
  
}



variable "aliases" {
    type = "list"
}

variable "default_root_object" {
  
}
variable "cached_methods" {
  type="list"
}
variable "headers" {
  type="list"
}


variable "allowed_methods" {
  type="list"
}

variable "target_origin_id" {
  
}

variable "forward_headers" {
  default = false
}

variable "forward_cookies" {
  default = "none"
}
variable "viewer_protocol_policy" {
  default="allow-all"
}

variable "min_ttl" {
  default = 0
}

variable "default_ttl" {
  default = 3600
}

variable "max_ttl" {
  default = 86400
}

variable "compress" {
  default = true
}

variable "restriction_type" {
  
}
variable "locations" {
  type = "list"
  default = ""
}
variable "acm_certificate_arn" {
  description = "Existing ACM Certificate ARN"
  default     = ""
}
variable "viewer_minimum_protocol_version" {
  description = "(Optional) The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
  default     = "TLSv1"
}
