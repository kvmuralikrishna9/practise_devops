variable "ami-id" {
    description = "AMI ID for ec2-instance"
}

variable "instance_type" {
    description = "Instance-type selection for EC2-Instance"
}

variable "key_name" {
    description = "Key-pair selection for EC2-Instance"
}

variable "ec2-01_name" {
    description = "Name of 1st EC2 instance"
}

variable "ec2_env_name" {
    description = "environment of 1st EC2 instance"
}

variable "vpc_security_group_ids" {
  description = "Security group IDs for the EC2 instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}