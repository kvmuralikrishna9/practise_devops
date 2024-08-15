output "EC2_ID" {
    value = aws_instance.ec2-tf_instance-001.id
}

output "public_IP" {
  value = aws_instance.ec2-tf_instance-001.public_ip
}

output "public_DNS" {
    value = aws_instance.ec2-tf_instance-001.public_dns
}

output "key_name" {
    value = aws_instance.ec2-tf_instance-001.key_name
}

output "vpc_id" {
    value = aws_instance.ec2-tf_instance-001.subnet_id  
}
