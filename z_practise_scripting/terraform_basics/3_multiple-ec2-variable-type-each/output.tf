output "VRP_Instance_Details" {
  value = {
    for ec2-name, instance in aws_instance.vrp_test_ec2 :

    ec2-name => {
      Instance_ID = instance.id
      Public_IP   = instance.public_ip
      Private_IP  = instance.private_ip
      Key_Name    = instance.key_name
    }
  }
}