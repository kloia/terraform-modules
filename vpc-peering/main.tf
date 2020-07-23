# Lookup requestor VPC
data "aws_vpc" "requestor" {
  id   = var.requestor_vpc_id
  tags = var.requestor_vpc_tags
}

# Lookup acceptor VPC
data "aws_vpc" "acceptor" {
  id   = var.acceptor_vpc_id
  tags = var.acceptor_vpc_tags
}

# Lookup requestor VPC route tables
data "aws_route_tables" "requestor" {
  vpc_id = data.aws_vpc.requestor.id
}

# Lookup acceptor VPC route tables
data "aws_route_tables" "acceptor" {
  vpc_id = data.aws_vpc.acceptor.id
}

# Create vpc peering
resource "aws_vpc_peering_connection" "default" {
  peer_vpc_id = data.aws_vpc.acceptor.id
  vpc_id      = data.aws_vpc.requestor.id
  auto_accept = var.auto_accept


  accepter {
    allow_remote_vpc_dns_resolution = var.acceptor_allow_remote_vpc_dns_resolution
  }

  requester {
    allow_remote_vpc_dns_resolution = var.requestor_allow_remote_vpc_dns_resolution
  }

  tags = var.tags
}


# Create routes from requestor to acceptor
resource "aws_route" "requestor" {
  count                     = length(data.aws_route_tables.requestor.ids)
  route_table_id            = tolist(data.aws_route_tables.requestor.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.acceptor.cidr_block_associations[0]["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
  depends_on                = [data.aws_route_tables.requestor, aws_vpc_peering_connection.default]
}

# Create routes from acceptor to requestor
resource "aws_route" "acceptor" {
  count                     = length(data.aws_route_tables.acceptor.ids)
  route_table_id            = tolist(data.aws_route_tables.acceptor.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.requestor.cidr_block_associations[0]["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
  depends_on                = [data.aws_route_tables.acceptor, aws_vpc_peering_connection.default]
}
