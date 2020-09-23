variable "peering_accepter_region" {
  description = "AWS Region"
  default     = "default"
}

variable "owner_vpc_id" {
  description = "Owner VPC Id"
}

variable "accepter_vpc_id" {
  description = "Accepter VPC Id"
}

variable "enable_accepter_route_modification" {
  description = "wheter to enable or not accepter route modifications."
  type        = bool
}
