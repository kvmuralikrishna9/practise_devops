output "Public_ip" {
  value = aws_instance.web.public_ip
}

output "Private_ip" {
  value = aws_instance.web.private_ip
}

output "tags" {
  value = aws_instance.web.tags_all
}