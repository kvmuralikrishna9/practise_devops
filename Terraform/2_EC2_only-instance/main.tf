# Creating EC2 Instance
resource "aws_instance" "ec2-tf-001" {
    ami = var.ami-ID
    availability_zone = var.ec2_availabiliy_zone
    subnet_id = var.subnet_id
    instance_type = var.instance_type
    key_name = var.key_name

    tags = {
      Name = "eks-tf_ec2"
      env = "development-team"
    }
}

resource "aws_instance" "ec2-tf-002" {
    ami = var.ami-ID
    availability_zone = var.ec2_availabiliy_zone
    #subnet_id = var.subnet_idh
    instance_type = var.instance_type
    key_name = var.key_name

    tags = {
      Name = "himanish"
      env = "prduction-team"
    }
}