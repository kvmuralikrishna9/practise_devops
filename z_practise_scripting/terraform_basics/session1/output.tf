output "VRP_Instance_Details" {
  value = {
    Instance_ID = aws_instance.vrp_test_ec2.id
    Public_IP   = aws_instance.vrp_test_ec2.public_ip
    Private_IP  = aws_instance.vrp_test_ec2.private_ip
  }
}