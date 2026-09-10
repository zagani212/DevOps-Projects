variable "aws_region" {
  type = string
}
variable "app_vpc_cidr" {
  type = string
}
variable "app_public_subnet_cidr" {
  type = list(string)
}
variable "app_private_subnet_cidr" {
  type = list(string)
}
variable "bastion_vpc_cidr" {
  type = string
}
variable "bastion_public_subnet_cidr" {
  type = list(string)
}

variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
