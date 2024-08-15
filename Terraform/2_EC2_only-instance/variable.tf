variable "ami-ID" {
    description = "AMI ID for ec2-instance"
}

variable "ec2_availabiliy_zone" {
    description = "Availibility zone for EC2 instance"
}


variable "subnet_id" {
    description = "subnet selection for EC2-Instance"
}

variable "instance_type" {
    description = "Instance-type selection for EC2-Instance"
}

variable "key_name" {
    description = "Key-pair selection for EC2-Instance"
}