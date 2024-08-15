output "vpc_id" {
    value = aws_vpc.eks-tf_vpc.id
}

output "cidr_block_pub_subnet" {
    value = aws_subnet.public_subnet.cidr_block
}

output "cidr_block_pub_subnet-2" {
    value = aws_subnet.public_subnet.cidr_block
}

output "subnet_id_output_pub" {
        value = aws_subnet.public_subnet.id
}

output "subnet_id_output_pub-2" {
        value = aws_subnet.public_subnet-2.id
}

output "sg_id_output" {
        value = aws_security_group.eks-tg_SG.id
}



/*
output "cidr_block_pvt_subnet" {
    value = aws_subnet.private_subnet.cidr_block
}


*output "subnet_id_output_pvt" {
        value = aws_subnet.private_subnet       # Outputs all subnet id's
}
*/