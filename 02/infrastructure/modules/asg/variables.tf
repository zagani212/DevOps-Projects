variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "sg" {
  type = string
}
variable "script_name" {
  type = string
}
variable "tg" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}