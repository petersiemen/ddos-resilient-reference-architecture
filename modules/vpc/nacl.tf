resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 0
    to_port    = 0
  }

  lifecycle {
    ignore_changes = [
    subnet_ids]
  }
}

resource "aws_network_acl" "public-subnets" {
  vpc_id = aws_vpc.this.id

  # allow ssh access from my ip address
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.my_ip_address}/32"
    from_port  = 22
    to_port    = 22
  }

  # deny ntp requests from everywhere to prevent DDoS reflection attacks
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 2049
    to_port    = 2049
  }

  # allow inbound return traffic from hosts on the internet that are responding to requests originating in the subnet.
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # we need to allow internet access on port 80 because the load balancer is deployed into the public subnets
  #
  # further the NAT is deplyed into the public subnet. In order to gain internet HTTP acccess from the private subnet we would need
  # to open port 80 for the cidr block of the vpc

  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    # aws_vpc.this.cidr_block
    from_port = 80
    to_port   = 80
  }

  #allow https connections
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }


  # allow ssh'ing through the vpc
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 22
    to_port    = 22
  }

  # allow outbound HTTP traffic from the subnet to the internet.
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # allow outbound traffic from the subnet to the internet (NAT instance talking to the internet, public ec2-instances talking back ssh)
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # allow outbound HTTPS traffic from the subnet to the internet.
  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "public-subnets"
  }

  subnet_ids = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
  aws_subnet.public-3.id]
}


resource "aws_network_acl" "private-subnets" {
  vpc_id = aws_vpc.this.id

  # allow ssh access from inside the vpc
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 22
    to_port    = 22
  }

  # allow inbound return traffic from hosts on the internet that are responding to requests originating in the subnet.
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # allow http traffic from the internet
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 80
    to_port    = 80
  }

  # allow inbound return traffic from hosts on the internet that are responding to requests originating in the subnet.
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # allow return traffic back to the vpc (ssh back to public subnet)
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  # allow outbound HTTP traffic to the internet
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # allow outbound traffic to the internet on port 3128 for pip
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }


  tags = {
    Name = "private-subnets"
  }

  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
  aws_subnet.private-3.id]
}
