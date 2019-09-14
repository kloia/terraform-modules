variable "sub_domain" {
  
}

variable "target_prefix" {
  
}

variable "ssl_state" {
  default = "flexible"
  type = "string"

}

variable "always_use_https" {
  default = false
}

variable "email_obfuscation" {
  default = "on"
  type = "string"
}

variable "minify_html" {
  default = "off"
}

variable "minify_js" {
  default = "off"
}

variable "minify_css" {
  default = "off"
}

variable "rocket_loader" {
  default = "off"
}
