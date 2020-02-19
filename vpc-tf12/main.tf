data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {

  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)


  tags = merge(
    {
      "Name" = format(
        "%s-${var.private_subnet_suffix}-%s",
        var.name,
        element(data.aws_availability_zones.available.names, count.index),
      ),
    },
    var.tags,
    var.private_subnet_tags,
  )
}

resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(data.aws_availability_zones.available.names)) ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = format(
        "%s-${var.public_subnet_suffix}-%s",
        var.name,
        element(data.aws_availability_zones.available.names, count.index),
      ),
    },
    var.tags,
    var.public_subnet_tags,
  )
}

resource "aws_internet_gateway" "igw" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.igw_tags,
  )
}


resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}", var.name)
    },
    var.tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format(
        "%s-${var.private_subnet_suffix}-%s",
        var.name,
        element(data.aws_availability_zones.available.names, count.index),
      )
    },
    var.tags,
  )

}

resource "aws_eip" "nat" {
  count = var.create_vpc && var.enable_nat_gateway ? length(var.public_subnets) : 0

  vpc = true

  tags = merge(
    {
      "Name" = format(
        "%s-eip-nat-%s",
        var.name,
        element(data.aws_availability_zones.available.names, count.index),
      )
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "ngw" {
  count = var.create_vpc && var.enable_nat_gateway ? length(var.public_subnets) : 0

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = merge(
    {
      "Name" = format(
        "%s-ngw-%s",
        var.name,
        element(data.aws_availability_zones.available.names, count.index),
      )
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private_nat_gateway" {
  count = var.create_vpc && var.enable_nat_gateway ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}


resource "aws_route_table_association" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id, count.index,
  )
}


resource "aws_route_table_association" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}
