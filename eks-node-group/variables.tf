variable "vpc_id" {
  description = "Id of the vpc for the cluster"
  type        = string
  default     = ""
}

variable "node_group_name" {
  description = "Name to be used for the node group"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "node_group_disk_size" {
  description = "Disk size in GiB for worker nodes."
  type        = number
  default     = 1
}

variable "node_group_instance_type" {
  description = "Set of instance types associated with the EKS Node Group."
  type        = list(string)
  default     = []
}

variable "kubernetes_labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "desired_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum worker capacity in the autoscaling group"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Minimum worker capacity in the autoscaling group."
  type        = number
  default     = 1
}

variable "cluster_endpoint" {
  description = "Eks Worker name arn for managed nodes"
  type        = string
  default     = ""
}

variable "source_security_group_ids" {
  description = "Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes. If you specify `ec2_ssh_key`, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)"
  type        = list(string)
  default     = []
}

variable "create_key_pair" {
  description = "Controls if key pair should be created"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "The name for the key pair."
  type        = string
  default     = ""
}


variable "public_key" {
  description = "The public key material."
  type        = string
  default     = ""
}
