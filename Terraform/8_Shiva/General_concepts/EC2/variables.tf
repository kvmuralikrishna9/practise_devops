variable "ami_id" {
  description = "value for ami_id"
  type = string
}

variable "number_of_instance" {
  description = "value for number of instance"
}

variable "instance_type" {
  description = "value for instance type"
  type = string
}

variable "SG_allowall" {
  description = "value for Security Group"
  type = list(string)
}

variable "instance_names" {
  description = "value for Instance name"
  type = list
}

variable "moretags" {
  description = "value for EC2 tags"
  type = map(string)
}