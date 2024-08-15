# Creating EC2 Instance

resource "aws_instance" "ec2-vrp-001" {
    
    availability_zone = data.aws_availability_zones.azs.names[0]
    ami               = var.ami-id
    instance_type     = var.instance_type
    key_name          = var.key_name
    vpc_security_group_ids = [module.VPC.SecurityGrp-ID.id]
    subnet_id         = module.VPC.PublicSubnet-id
    user_data         = file("./Install_jenkins.sh")
    associate_public_ip_address = true

    tags = {
      Name = var.ec2-01_name
      env  = var.ec2_env_name
    }
  
}
