## Values are just for the refernce, we can go as we like".

# Variables values for VPC Module
aws-region                = "ap-south-1"
vpc_name                  = "VRP-Products"
vpc_cidr_block            = "11.0.0.0/16"
vpc_igw                   = "VRP-Products_igw"
env_name                  = "dev-environment"
cidr_block_pub_subnet     = "11.0.1.0/24"
availability_zone_pub_sub = "ap-south-1a"
public_subnet_name        = "VRP_Pub-subnet"
sg_tag_name               = "VRP_SecurityGrp"
sg_name                   = "VRP_SecurityGrp"
cidr_block_pvt_subnet     = "11.0.4.0/24"
availability_zone_pvt_sub = "ap-south-1b"
private_subnet_name       = "VRP-Private-subnet"
route_table_name          = "VRP-Route-table"


# Variables values for EC2 Module
ami-id        = "ami-0e4fd655fb4e26c30"     #amazon ami
instance_type = "t2.micro"
key_name      = "mumbai"
ec2-01_name   = "ec2-vrp-001"
ec2_env_name  = "development-team"