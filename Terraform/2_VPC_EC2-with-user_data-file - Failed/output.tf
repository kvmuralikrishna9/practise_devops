/*output "ec2-Instance Private" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.EC2.ec2-vrp-001.private_ip
}

output "EC2_ID" {
    value = aws_instance.ec2-vrp-001.id
}

output "public_IP" {
  value = aws_instance.ec2-vrp-001.public_ip
}

output "public_DNS" {
    value = aws_instance.ec2-vrp-001.public_dns
}

output "key_name" {
    value = aws_instance.ec2-vrp-001.key_name
}

output "vpc_id" {
    value = aws_instance.ec2-vrp-001.subnet_id  
}*/