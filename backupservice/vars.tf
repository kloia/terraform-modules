variable "servicename" {
  type        = "string"
  description = "Service name that should be used on backup taken process"
}

variable "kms_arn" {
  type        = "string"
  description = "KMS key ARN for encryption"
}

variable "cron_expression" {
  type        = "string"
  description = "KMS key ARN for encryption"
}

variable "delete_after"{
  type        = "string"
  description = "Specify the retention day of taken backups"
}
variable "resource_arn" {
  type        = "string"
  description = "Resource arn that will be applied backup taken process"
}
