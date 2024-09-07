variable "ami_id" {
  description = "value for ami_id"
  type = string
}

variable "instance_type" {
  description = "value for instance type"
  type = string
}

variable "SG_allowall" {
  description = "value for Security Group"
  type = list(string)
}

variable "ec2_tags" {
  description = "value for EC2 tags"
  type = map(string)
}