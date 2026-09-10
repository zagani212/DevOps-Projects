variable "bastion_vpc_id" {
  type = string
}
variable "app_vpc_id" {
  type = string
}
variable "bastion_cidr" {
  type = string
  default = ""
}