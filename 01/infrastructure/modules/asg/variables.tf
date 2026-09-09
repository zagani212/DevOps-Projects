variable "alb_target_group" {
  type = string
}
variable "sg" {
  type = string
}
variable "key_name" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "name" {
  type = string
}
variable "script_name" {
  type = string
}
variable "iam_instance_profile" {
  type = string
  default = null
}
variable "app_lb_dns_name" {
  type = string
  default = "TEST"
}