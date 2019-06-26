variable "requester_profile" {
  description = "Requester AWS Profile"
  type        = "string"
}

variable "requester_region" {
  type        = "string"
  description = "Requester AWS region"
  default = "eu-central-1"
}

variable "requester_vpc_id" {
  type        = "string"
  description = "Requester VPC ID filter"
  default     = ""
}

variable "requester_vpc_tags" {
  type        = "map"
  description = "Requester VPC Tags filter"
  default     = {}
}

variable "requester_allow_remote_vpc_dns_resolution" {
  default     = "true"
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
}

# Requestors's credentials
provider "aws" {
  alias  = "requester"
  region = "${var.requester_region}"
  profile = "${var.requester_profile}"
}

locals {
  requester_attributes = "${concat(var.attributes, list("requester"))}"
  requester_tags       = "${merge(var.tags, map("Side", "requester"))}"
}

data "aws_caller_identity" "requester" {
  count    = "${local.count}"
  provider = "aws.requester"
}

data "aws_region" "requester" {
  count    = "${local.count}"
  provider = "aws.requester"
}

# Lookup requester VPC so that we can reference the CIDR
data "aws_vpc" "requester" {
  count    = "${local.count}"
  provider = "aws.requester"
  id       = "${var.requester_vpc_id}"
  tags     = "${var.requester_vpc_tags}"
}

# Lookup requester subnets
data "aws_subnet_ids" "requester" {
  count    = "${local.count}"
  provider = "aws.requester"
  vpc_id   = "${local.requester_vpc_id}"
}

locals {
  requester_subnet_ids       = "${distinct(sort(flatten(data.aws_subnet_ids.requester.*.ids)))}"
  requester_subnet_ids_count = "${length(local.requester_subnet_ids)}"
  requester_vpc_id           = "${join("", data.aws_vpc.requester.*.id)}"
}

# Lookup requester route tables
data "aws_route_table" "requester" {
  count     = "${local.enabled ? local.requester_subnet_ids_count : 0}"
  provider  = "aws.requester"
  subnet_id = "${element(local.requester_subnet_ids, count.index)}"
}

resource "aws_vpc_peering_connection" "requester" {
  count         = "${local.count}"
  provider      = "aws.requester"
  vpc_id        = "${local.requester_vpc_id}"
  peer_vpc_id   = "${local.accepter_vpc_id}"
  peer_owner_id = "${local.accepter_account_id}"
  peer_region   = "${local.accepter_region}"
  auto_accept   = true
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider = "aws.requester"

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = "${join("", aws_vpc_peering_connection.requester.*.id)}"

  requester {
    allow_remote_vpc_dns_resolution = "${var.requester_allow_remote_vpc_dns_resolution}"
  }
  depends_on = ["aws_vpc_peering_connection.requester.*.id", "null_resource.delay_request"]
}



resource "null_resource" "delay_request" {
  provisioner "local-exec" {
    command = "sleep 10"
  }
  triggers = {
    "before" = "${aws_vpc_peering_connection_options.requester.id}"
  }
}

locals {
  requester_aws_route_table_ids           = "${distinct(sort(data.aws_route_table.requester.*.route_table_id))}"
  requester_aws_route_table_ids_count     = "${length(local.requester_aws_route_table_ids)}"
  requester_cidr_block_associations       = "${flatten(data.aws_vpc.requester.*.cidr_block_associations)}"
  requester_cidr_block_associations_count = "${length(local.requester_cidr_block_associations)}"
}

# Create routes from requester to accepter
resource "aws_route" "requester" {
  count                     = "${local.enabled ? local.requester_aws_route_table_ids_count * local.accepter_cidr_block_associations_count : 0}"
  provider                  = "aws.requester"
  route_table_id            = "${element(local.requester_aws_route_table_ids, ceil(count.index/local.accepter_cidr_block_associations_count))}"
  destination_cidr_block    = "${lookup(local.accepter_cidr_block_associations[count.index % local.accepter_cidr_block_associations_count], "cidr_block")}"
  vpc_peering_connection_id = "${join("", aws_vpc_peering_connection.requester.*.id)}"
  depends_on                = ["data.aws_route_table.requester", "aws_vpc_peering_connection.requester", "aws_vpc_peering_connection_accepter.accepter"]
}

output "requester_connection_id" {
  value       = "${join("", aws_vpc_peering_connection.requester.*.id)}"
  description = "Requester VPC peering connection ID"
}

output "requester_accept_status" {
  value       = "${join("", aws_vpc_peering_connection.requester.*.accept_status)}"
  description = "Requester VPC peering connection request status"
}
