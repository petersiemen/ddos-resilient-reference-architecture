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

  # allow outbound HTTP traffic from the subnet to the internet.
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # allow outbound traffic from the subnet to my ip address
  # Note: even ssh is beeing transported back on ephemeral ports (1024 - 65535)
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "${var.my_ip_address}/32"
    from_port  = 1024
    to_port    = 65535
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

  # ssh access from everywhere within the vpc
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 22
    to_port    = 22
  }

  # Allows inbound return traffic from hosts on the internet that are responding to requests originating in the subnet.
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }


  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # allow outbound traffic to the NAT
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "private-subnets"
  }

  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
  aws_subnet.private-3.id]
}
