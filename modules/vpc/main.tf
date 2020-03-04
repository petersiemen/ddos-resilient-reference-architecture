resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true

  tags = {
    Name = "${var.organization}-${var.env}-custom-vpc"
  }
}
# public subnets
resource "aws_subnet" "public-1" {
  #10.0.1.0/24
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 1)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-2" {
  #10.0.2.0/24
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 2)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
  tags = {
    Name = "public-2"
  }
}
resource "aws_subnet" "public-3" {
  #10.0.3.0/24
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 3)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1c"
  tags = {
    Name = "public-3"
  }
}

resource "aws_subnet" "private-1" {
  #10.0.101.0/24
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, 101)
  vpc_id            = aws_vpc.this.id
  availability_zone = "eu-central-1b"
  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private-2" {
  #10.0.102.0/24
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, 102)
  vpc_id            = aws_vpc.this.id
  availability_zone = "eu-central-1c"
  tags = {
    Name = "private-2"
  }
}


resource "aws_subnet" "private-3" {
  #10.0.103.0/24
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, 103)
  vpc_id            = aws_vpc.this.id
  availability_zone = "eu-central-1c"
  tags = {
    Name = "private-3"
  }
}


# default Security Group, Network Access Control List and Route Table is created when a custom VPC is created

# now we create a new route table here and associate the subnet that generates public ips for ec2-instances launced into it
# we keep the private subnet associated to the main route table (by default). By doing so we make sure that
resource "aws_internet_gateway" "internet-gateway-for-public-subnets" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-igw"
  }
}

resource "aws_eip" "elastic-ip-for-nat-gateway-1" {
  vpc = true
}
resource "aws_eip" "elastic-ip-for-nat-gateway-2" {
  vpc = true
}
resource "aws_eip" "elastic-ip-for-nat-gateway-3" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway-for-private-subnet-1" {
  subnet_id     = aws_subnet.public-1.id
  allocation_id = aws_eip.elastic-ip-for-nat-gateway-1.id
}

resource "aws_nat_gateway" "nat-gateway-for-private-subnet-2" {
  subnet_id     = aws_subnet.public-2.id
  allocation_id = aws_eip.elastic-ip-for-nat-gateway-2.id
}

resource "aws_nat_gateway" "nat-gateway-for-private-subnet-3" {
  subnet_id     = aws_subnet.public-3.id
  allocation_id = aws_eip.elastic-ip-for-nat-gateway-3.id
}

resource "aws_route_table" "route-table-for-public-1" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-public-1-non-main"
  }
}

resource "aws_route_table" "route-table-for-public-2" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-public-2-non-main"
  }
}

resource "aws_route_table" "route-table-for-public-3" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-public-3-non-main"
  }
}

resource "aws_route_table" "route-table-for-private-1" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-private-1-non-main"
  }
}

resource "aws_route_table" "route-table-for-private-2" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-private-2-non-main"
  }
}

resource "aws_route_table" "route-table-for-private-3" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-private-3-non-main"
  }
}


resource "aws_route_table_association" "public-subnet-1-to-public-route-table" {
  route_table_id = aws_route_table.route-table-for-public-1.id
  subnet_id      = aws_subnet.public-1.id
}

resource "aws_route_table_association" "public-subnet-2-to-public-route-table" {
  route_table_id = aws_route_table.route-table-for-public-2.id
  subnet_id      = aws_subnet.public-2.id
}

resource "aws_route_table_association" "public-subnet-3-to-public-route-table" {
  route_table_id = aws_route_table.route-table-for-public-3.id
  subnet_id      = aws_subnet.public-3.id
}


resource "aws_route_table_association" "private-subnet-1-to-private-route-table" {
  route_table_id = aws_route_table.route-table-for-private-1.id
  subnet_id      = aws_subnet.private-1.id
}

resource "aws_route_table_association" "private-subnet-2-to-private-route-table" {
  route_table_id = aws_route_table.route-table-for-private-2.id
  subnet_id      = aws_subnet.private-2.id
}

resource "aws_route_table_association" "private-subnet-3-to-private-route-table" {
  route_table_id = aws_route_table.route-table-for-private-3.id
  subnet_id      = aws_subnet.private-3.id
}


resource "aws_route" "internet-gateway-route-for-public-1" {
  route_table_id         = aws_route_table.route-table-for-public-1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gateway-for-public-subnets.id
}

resource "aws_route" "internet-gateway-route-for-public-2" {
  route_table_id         = aws_route_table.route-table-for-public-2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gateway-for-public-subnets.id
}

resource "aws_route" "internet-gateway-route-for-public-3" {
  route_table_id         = aws_route_table.route-table-for-public-3.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gateway-for-public-subnets.id
}

resource "aws_route" "nat-gateway-route-for-private-1" {
  route_table_id         = aws_route_table.route-table-for-private-1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway-for-private-subnet-1.id
}

resource "aws_route" "nat-gateway-route-for-private-2" {
  route_table_id         = aws_route_table.route-table-for-private-2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway-for-private-subnet-2.id
}

resource "aws_route" "nat-gateway-route-for-private-3" {
  route_table_id         = aws_route_table.route-table-for-private-3.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway-for-private-subnet-3.id
}
