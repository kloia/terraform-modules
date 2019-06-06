variable "cloudflarekey" {
  default = "cloudflarekey"
}
variable "cloudflareemail" {
  default = "cloudflareemail"
}

variable "count" {
  default = 1
}

variable "cname_record_address" {
  default = ""
}


variable "ttl" {
  default = 1
}

variable "name_servers" {
  type= "list"
  default = [""]
}

variable "cloudflare_count" {
  default = 1
}

variable "create_ns_record" {
  default = 1
}


variable "use_route53_ns_record" {
  default = 0
}

variable "cloudflare_ttl" {
  default = 1
}


variable "cloudflare_domain_name" {
  default = ""
}

variable "cloudflare_domain" {
  default = ""
}


variable "cloudflare_domain_ns" {
  
}

