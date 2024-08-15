## Values are just for the refernce, we can go as we like".

# Variables from VPC Module
vpc_cidr_block              = "11.0.0.0/16"
vpc_name                    = "eks-tf_vpc"
vpc_igw                     = "eks-tf_vpc_igw"
env_name                    = "dev-environment"
cidr_block_pub_subnet       = "11.0.1.0/24"
availability_zone_pub_sub   = "ap-south-1a"
public_subnet_name          = "eks-tf-public_subnet"
cidr_block_pub_subnet-2     = "11.0.2.0/24"
availability_zone_pub_sub-2 = "ap-south-1b"
public_subnet_name-2        = "eks-tf-public_subnet-2"
sg_tag_name                 = "eks-tg_SG"
sg_name                     = "eks-tg_SG"
#cidr_block_pvt_subnet     = "11.0.3.0/24"
#availability_zone_pvt_sub = "ap-south-1a"
#private_subnet_name       = "eks-tf-private_subnet"
route_table_name    = "eks-tf_vpc_route_tale"
public_access_cidrs = ["0.0.0.0/0"]

# Variables from EKS Module
cidr_pub_subnet         = "11.0.1.0/24"
cidr_pub_subnet-2       = "11.0.2.0/24"
cluster_name            = "eks-tf_cluster" # Must match with "Name" (Line 3) from main.tf 
endpoint_private_access = "false"          # true/false  
endpoint_public_access  = "true"           # true/false
node_group_name         = "eks-tf_Node_group"
scaling_desired_size    = "1" # number
scaling_max_size        = "2"
scaling_min_size        = "1"
instance_types          = "t2.medium"
#security_group_id      = "sg-00123545abcdef"
cluster_role_arn    = "arn:aws:iam::554568167212:role/eks_cluster_role"    # IAM Cluster Role arn#
node_group_role_arn = "arn:aws:iam::554568167212:role/eks_node_group_role" # IAM Cluster Role arn#


# Inputs for IAM Variables
cluster_role_name        = "eks_cluster_role"
eks_node_group_role_name = "eks_node_group_role"
