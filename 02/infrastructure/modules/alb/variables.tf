variable "name" {
  type = string
}
variable "internal" {
  type = bool
}
variable "sg" {
  type = string
}
variable "subnet" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}