data "template_file" "user_data" {
  template = base64encode(file("${path.module}/user-data.sh"))
}

resource "aws_instance" "jumphost" {
  ami                  = var.aws_linux_2_ami
  instance_type        = "t2.micro"
  key_name             = var.iam__admin_key_name
  iam_instance_profile = var.iam__aws_iam_instance_profile_ec2_name

  subnet_id = var.vpc__public_subnet_1_id

  vpc_security_group_ids = [
    var.vpc__security_group_dmz_id
  ]

  user_data = data.template_file.user_data.rendered

  tags = {
    Name        = "jumphost"
    Hostname    = "jumphost"
    Role        = "jumphost"
    Environment = var.env
  }

}
