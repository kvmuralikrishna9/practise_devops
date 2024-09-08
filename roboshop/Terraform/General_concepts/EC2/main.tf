# Provisioning an EC2 instance 
resource "aws_instance" "web" {
  count           = var.number_of_instance
  ami             = var.ami_id
  instance_type   = var.instance_type
  vpc_security_group_ids = var.SG_allowall
  associate_public_ip_address = true

  tags = { 
    Name     = var.instance_names[count.index]
    #moretags = var.moretags
  }
}