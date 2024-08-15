output "vpc_id_output" {
    value = aws_vpc.deploy_eks_using_tf_jenkins_vpc.id
}

output "sg_id_output" {
        value = aws_security_group.eks-tg_SG.id
}

output "subnet_id_output_pub" {
        value = aws_subnet.public_subnet.id
}

output "cidr_block_pub_subnet" {
    value = aws_subnet.public_subnet.cidr_block
}


output "cidr_block_pvt_subnet" {
    value = aws_subnet.private_subnet.cidr_block
}

output "subnet_id_output_pvt" {
        value = aws_subnet.private_subnet.id    # Outputs all subnet id's
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}