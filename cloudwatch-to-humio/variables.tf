variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "cwlogsr"
}

variable "humio_dataspace_name" {
  type        = string
  description = "The name of your dataspace in humio that you want to ship logs to."
  default     = ""
}

variable "humio_protocol" {
  type        = string
  description = "The transport protocol used for delivering log events to Humio. HTTPS is default and recommended."
  default     = "https"
}

variable "humio_host" {
  type        = string
  description = "The host you want to ship your humio logs to."
  default     = "cloud.humio.com"
}

variable "humio_ingest_token" {
  type        = string
  description = "The value of your ingest token from your Humio account.."
  default     = ""
}

variable "humio_auto_subscription" {
  type        = bool
  description = "The Humio Ingester will automatically subscribe to new log groups you specify with the prefix below. Set to 'true' to enable."
  default     = true
}

variable "humio_subscription_backfiller" {
  type        = bool
  description = "Enabling this will backfill older log groups that existed before Humio was installed. This will run every time a new log group is created."
  default     = true
}

variable "humio_subscription_prefix" {
  type        = string
  description = "Humio will only subscribe to log groups with the prefix you specify"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "runtime" {
  type        = string
  description = "Runtime for lambda function"
  default     = "python2.7"
}

variable "memory_size" {
  type        = string
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = "128"
}

variable "timeout" {
  type        = string
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = "300"
}
