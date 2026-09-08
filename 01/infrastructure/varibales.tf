variable "environment" {
  type = string
}
variable "aws_region" {
  type = string
  default = "eu-west-3"
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "key_name" {
  type = string
}