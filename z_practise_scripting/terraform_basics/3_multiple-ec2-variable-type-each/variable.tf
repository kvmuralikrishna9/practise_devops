#variable "vrp_ami" {}
variable "vrp_instance_type" {
    type = map(string)
    default = {
      "web"         = "t2.micro"
      "mongodb"     = "t3.medium"
      "catalogue"   = "t2.micro"
      "redis6"      = "t3.medium"
      "cart"        = "t2.micro"
      "user"        = "t2.micro"
      "mysql"       = "t3.medium"
      "shipping"    = "t2.micro"
      "rabbitmq"    = "t3.medium"
      "payment"     = "t2.micro"
      "dispatch"    = "t2.micro"

    }
}

variable "vrp_iam_role" {}
variable "vrp_pemkey" {}
variable "vrp_sg" { type = string }
variable "vrp_pvt_subnet" {}