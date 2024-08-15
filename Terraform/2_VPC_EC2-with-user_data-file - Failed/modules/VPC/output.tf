output "vpc-id" {
  value = aws_vpc.VRP-Products_VPC.id
}

output "SecurityGrp-ID" {
  value = aws_security_group.eks-tg_SG.id
}

output "PublicSubnet-id" {
  value = aws_subnet.public_subnet.id
}

output "PublicSubnet-CIDR" {
  value = aws_subnet.public_subnet.cidr_block
}

output "PrivateSubnet-id" {
  value = aws_subnet.private_subnet.id # Outputs all subnet id's
}

output "PrivateSubnet-CIDR" {
  value = aws_subnet.private_subnet.cidr_block
}

