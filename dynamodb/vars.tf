
variable "name" {
  type        = "string"
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "billing_mode" {
  type        = "string"
  default     = "PAY_PER_REQUEST"
  description = "DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST"
}

variable "hash_key" {
  type        = "string"
  description = "DynamoDB table Hash Key"
}

variable "hash_key_type" {
  type        = "string"
  default     = "S"
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "range_key" {
  type        = "string"
  default     = ""
  description = "DynamoDB table Range Key"
}

variable "range_key_type" {
  type        = "string"
  default     = "S"
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}


variable "read_capacity" {
  type = "string"
  default = 5
  description = "(optional) describe your variable"
}

variable "write_capacity" {
  type = "string"
  default = 5
  description = "(optional) describe your variable"
}
variable "replication_region" {
  type = "string"
  default = ""
  description = "Region for disaster recovery capablities, for global table "
}
variable "is_stream_enabled" {
  type = "string"
  default = true
}


