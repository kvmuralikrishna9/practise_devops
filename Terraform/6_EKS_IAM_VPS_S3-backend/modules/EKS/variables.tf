variable "subnet_ids" {
    description = "Public subnet id's"
    type        = list(string)
}

variable "vpc_id" {
    description = "VPC ID"
}

variable "cluster_name" {
    description = "Cluster name"
}

variable "endpoint_private_access" {
    description = "EKS Endpoint private access status"
}

variable "endpoint_public_access" {
    description = "EKS Endpoint public access status"
}

variable "public_access_cidrs" {
    description = "CIDR's for EKS public access"
    type        = list(string)
}

variable "node_group_name" {
    description = "Node group name"
}

variable "scaling_desired_size" {
    description = "Node group scaling "
}

variable "scaling_max_size" {
    description = "Scaling max size"
}

variable "scaling_min_size" {
    description = "Scaling min size"
}

variable "instance_types" {
    description = "Node group instance type"
#    type        = list(string)
}

/*variable "security_group_id" {
    description = "EKS cluster security group"
}
*/
variable "env_name" {
    description = "Environment tag"
}

variable "cluster_role_arn" {
    description = "Cluster role ARN"
}

variable "node_group_role_arn" {
    description = "Node group role ARN"
}

variable "cidr_pub_subnet" {
     description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "cidr_pub_subnet-2" {
     description = "Public subnet CIDR blocks"
  type        = list(string)
}



/*
variable "instance_type_ubuntu_medium" {            # If need to use "Launch Template" 
  description = "The instance types to use for the node group"
  type        = map
}

variable "ami_id_ubuntu_medium" {
  description = "The AMI IDs to use for the node group"
  type        = map
}
*/
