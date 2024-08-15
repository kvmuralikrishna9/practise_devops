# Variables from VPC modules

variable "aws-region" {}
variable "vpc_cidr_block" {}
variable "vpc_name" {} # Map the values from modules "variables.tf"
variable "vpc_igw" {}
variable "env_name" {}
variable "public_subnet_name" {}
variable "availability_zone_pub_sub" {}
variable "cidr_block_pub_subnet" {}
variable "private_subnet_name" {}
variable "availability_zone_pvt_sub" {}
variable "cidr_block_pvt_subnet" {}
variable "route_table_name" {}
variable "sg_tag_name" {}
variable "sg_name" {}


# Variables from EC2 modules

variable "ami-id" {}
variable "instance_type" {}
variable "key_name" {}
variable "ec2_env_name" {}
variable "ec2-01_name" {}