variable "aws-region" {
    description = "Location to create the VPC"
}

variable "vpc_name" {
  description = "Name tag for VPC"
}

variable "vpc_cidr_block" {
  description = "CIDR block values for VPC"
}


variable "env_name" {
  description = "Name tag for VPC"
}

variable "cidr_block_pub_subnet" {
  description = "CIDR block for Public Subnet"
  type        = string
}

variable "availability_zone_pub_sub" {
  description = "Availability Zone for Public Subnet"
}

variable "public_subnet_name" {
  description = "Name for Public Subnet"
}

variable "cidr_block_pvt_subnet" {
  description = "CIDR block for Public Subnet"
  type        = string
}

variable "availability_zone_pvt_sub" {
  description = "Availability Zone for Private Subnet"
}

variable "private_subnet_name" {
  description = "Name for Public Subnet"
}

variable "vpc_igw" {
  description = "Name for Internet Gateway"
}

variable "route_table_name" {
  description = "Name for Route table"
}

variable "sg_name" {
  description = "SG name"
}

variable "sg_tag_name" {
  description = "SG name tag"
}