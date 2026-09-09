resource "aws_db_instance" "default" {
  allocated_storage           = 20
  # backup_retention_period     = 7
  db_subnet_group_name        = var.db_subnet_group_name
  engine                      = "mysql"
  db_name = var.db_name
  publicly_accessible = false
  skip_final_snapshot = true
  identifier                  = "ee-instance-demo"
  instance_class              = "db.t4g.micro"
  multi_az                    = false
  password                    = var.password
  username                    = var.username
  vpc_security_group_ids = [var.sg]
}