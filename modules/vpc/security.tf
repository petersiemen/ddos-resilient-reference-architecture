resource "aws_security_group" "dmz" {
  name   = "${var.organization}-${var.env}-dmz"
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-dmz"
  }
}

resource "aws_security_group" "private" {
  name   = "${var.organization}-${var.env}-private"
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-private"
  }
}

resource "aws_security_group" "lb" {
  name   = "${var.organization}-${var.env}-lb"
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.organization}-${var.env}-lb"
  }
}

resource "aws_security_group" "cloudfront-global-https" {
  name   = "${var.organization}-${var.env}-cf-global-https"
  vpc_id = aws_vpc.this.id
  tags = {
    Name       = "cloudfront_g"
    AutoUpdate = true
    Protocol   = "https"
  }
}

resource "aws_security_group" "cloudfront-global-http" {
  name   = "${var.organization}-${var.env}-cf-global-http"
  vpc_id = aws_vpc.this.id
  tags = {
    Name       = "cloudfront_g"
    AutoUpdate = true
    Protocol   = "http"
  }
}
resource "aws_security_group" "cloudfront-regional-https" {
  name   = "${var.organization}-${var.env}-cf-regional-https"
  vpc_id = aws_vpc.this.id
  tags = {
    Name       = "cloudfront_r"
    AutoUpdate = true
    Protocol   = "https"
  }
}

resource "aws_security_group" "cloudfront-regional-http" {
  name   = "${var.organization}-${var.env}-cf-regional-http"
  vpc_id = aws_vpc.this.id
  tags = {
    Name       = "cloudfront_r"
    AutoUpdate = true
    Protocol   = "http"
  }
}


resource "aws_security_group_rule" "all-http-into-lb" {
  from_port         = 80
  protocol          = "TCP"
  security_group_id = aws_security_group.lb.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "all-https-into-lb" {
  from_port         = 443
  protocol          = "TCP"
  security_group_id = aws_security_group.lb.id
  to_port           = 443
  type              = "ingress"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "all-http-out-from-lb" {
  from_port         = 80
  protocol          = "TCP"
  security_group_id = aws_security_group.lb.id
  to_port           = 80
  type              = "egress"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "ssh-into-private-from-dmz" {
  from_port                = 22
  protocol                 = "TCP"
  security_group_id        = aws_security_group.private.id
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = aws_security_group.dmz.id
}

resource "aws_security_group_rule" "http-into-private-from-lb" {
  from_port                = 80
  protocol                 = "TCP"
  security_group_id        = aws_security_group.private.id
  to_port                  = 80
  type                     = "ingress"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "http-into-private-from-dmz" {
  from_port                = 80
  protocol                 = "TCP"
  security_group_id        = aws_security_group.private.id
  to_port                  = 80
  type                     = "ingress"
  source_security_group_id = aws_security_group.dmz.id
}

resource "aws_security_group_rule" "all-out-from-dmz" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.dmz.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks = [
  "0.0.0.0/0"]
}

resource "aws_security_group_rule" "all-out-from-private" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.private.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks = [
  "0.0.0.0/0"]
}


resource "aws_security_group_rule" "ssh-into-dmz-from-home" {
  from_port         = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.dmz.id
  to_port           = 22
  type              = "ingress"

  cidr_blocks = [
    "${var.my_ip_address}/32",
  ]
}



resource "aws_security_group_rule" "all-out-from-cf-global-https" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.cloudfront-global-https.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks = [
  "0.0.0.0/0"]
}

resource "aws_security_group_rule" "all-out-from-cf-regional-https" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.cloudfront-regional-https.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks = [
  "0.0.0.0/0"]
}

resource "aws_security_group_rule" "all-out-from-cf-global-http" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.cloudfront-global-http.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks = [
  "0.0.0.0/0"]
}

resource "aws_security_group_rule" "all-out-from-cf-regional-http" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.cloudfront-regional-http.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks = [
  "0.0.0.0/0"]
}