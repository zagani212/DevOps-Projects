resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.sg]
  subnet_id = var.subnet_id
  tags = {
    Name = var.name
  }
}