# Provisioning an EC2 instance 
resource "aws_instance" "web" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  vpc_security_group_ids = var.SG_allowall
  associate_public_ip_address = true

  tags = var.ec2_tags
}