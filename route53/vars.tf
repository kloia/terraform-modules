variable "domain" {
}


variable "name" {
  default = ""
}### Input of domain (sub.domain.com)

variable "weight" {
  default = 90
}


variable "name_servers" {
  type = "list"
  default = []
}

variable "set_identifier" {
  default = 1
}

variable "records" {
    description = "Records"
    default = ""
}

variable "ttl" {
  default = "30"
}

variable "type" {
  default = "NS"
}

variable "record_ns" {
    default = 0

}


variable "record_cname" {
    default = 0

}

variable "other_record" {
  default = 0
}
