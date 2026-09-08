variable "subnets" {
  type = list(string)
}
variable "sg" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "name" {
  type = string
}
variable "internal" {
  type = bool
}