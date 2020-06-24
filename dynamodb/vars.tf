
variable "name" {
  type        = "string"
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "billing_mode" {
  type        = "string"
  default     = "PROVISIONED"
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

variable "dynamodb_attributes" {
  type        = "list"
  default     = []
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
}
