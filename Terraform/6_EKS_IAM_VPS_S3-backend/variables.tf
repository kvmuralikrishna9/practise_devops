# Variables from Provider
variable "eks-region" {}

# Variables from VPC modules
variable "vpc_cidr_block" {}
variable "vpc_name" {} # Map the values from modules "variables.tf"
variable "vpc_igw" {}
variable "env_name" {}
variable "public_subnet_name" {}
variable "availability_zone_pub_sub" {}
variable "cidr_block_pub_subnet" {}
variable "public_subnet_name-2" {}
variable "availability_zone_pub_sub-2" {}
variable "cidr_block_pub_subnet-2" {}
#variable "private_subnet_name" {}
#variable "availability_zone_pvt_sub" {}
#variable "cidr_block_pvt_subnet" {}
variable "route_table_name" {}
variable "sg_tag_name" {}
variable "sg_name" {}


# Variables from EKS modules
#variable "vpc_id" {}
variable "cluster_name" {}
variable "cluster_role_arn" {}
variable "instance_types" {}
#variable "security_group_id" {}
variable "cidr_pub_subnet" {}
variable "cidr_pub_subnet-2" {}
variable "public_access_cidrs" {}
variable "node_group_name" {}
variable "node_group_role_arn" {}
variable "endpoint_public_access" {}
variable "endpoint_private_access" {}
variable "scaling_desired_size" {}
variable "scaling_min_size" {}
variable "scaling_max_size" {}

# Variables from IAM
variable "cluster_role_name" {}
variable "vrp_node_group_role_name" {}
