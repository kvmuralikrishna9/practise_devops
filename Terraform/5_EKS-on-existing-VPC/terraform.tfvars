# Values are just for the refernce, we can go as we like".

cidr_pub_subnet = ["subnet-000abc123xyz", "subnet-000abc123xyz"] # Subnets must be same availability zone
vpc_id = "vpc-000abc123xyz"   
cluster_name = "eks-tf_cluster_node"      # Must match with "Name" (Line 3) from main.tf 
endpoint_private_access = "false"        # true/false  
endpoint_public_access = "true"          # true/false
public_access_cidrs = ["0.0.0.0/0"]
node_group_name = "eks-tf_cluster_node" 
scaling_min_size = "2"              # min_size must be less than max_zize or equal to desired_size
scaling_desired_size = "2"          # Desired should be lessthan max_size or equal to min_size
scaling_max_size = "3"              # max_size should be greaterthan desired & min_size
instance_types = ["t2.medium"]
##security_group_id = "sg-0000abc123xyz"   
env_name = "dev-environmnet"
cluster_role_arn = "arn:aws:iam::<AWS_12-DIGIT_ID>:role/eks_cluster_role"            # IAM Cluster Role arn#
node_group_role_arn = "arn:aws:iam::<AWS_12-DIGIT_ID>:role/eks_node_group_role"      # IAM Cluster Role arn#
#instance_type_ubuntu_medium = "t2.medium"
#ami_id_ubuntu_medium = "ami-xxxxxx"