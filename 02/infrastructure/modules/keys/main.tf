resource "aws_key_pair" "main" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}