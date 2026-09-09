resource "aws_secretsmanager_secret" "app" {
  name = "login-app-db-secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id = aws_secretsmanager_secret.app.id

  secret_string = jsonencode({
    username = var.username
    password = var.password
    dbname = var.db_name
    port = var.port
    host     = var.host
  })
}