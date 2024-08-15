# Creating EKS Cluster
resource "aws_eks_cluster" "vrp_cluster" {
    name = var.cluster_name
    role_arn = var.cluster_role_arn

    vpc_config {
      subnet_ids              = var.subnet_ids  #last 
      endpoint_public_access  = var.endpoint_public_access
      endpoint_private_access = var.endpoint_private_access
      public_access_cidrs     = var.public_access_cidrs
      #security_group_ids      = var.security_group_id
    }

    tags = {
    env = var.env_name
  }
}

# Creating EKS Node Group
resource "aws_eks_node_group" "vrp_cluster_node" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_group_role_arn

  subnet_ids      = var.subnet_ids   #last 
  
  instance_types  = [var.instance_types]

 /* launch_template {       # Specicy the ami-id and insytance type                
    name_prefix = "eks-node-group-template"
    version     = "$Latest"

    instance_type = var.instance_type_ubuntu_medium
    ami_id        = var.ami_id_ubuntu_medium
  }
  */

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

  depends_on = [aws_eks_cluster.vrp_cluster]
}