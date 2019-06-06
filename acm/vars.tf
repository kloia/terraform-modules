variable "is_route53" {
  default = 0
}

variable "is_cloudflare" {
  default = 0
}

variable "domain_name" {
}

variable "validation_method" {
  default = "DNS"
}


variable "acm_ttl" {
  default = 60
}


variable "cloudflare_key" {
  default = "cloudflarekey"
}

variable "cloudflare_email" {
    default = "cloudflareemail"
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