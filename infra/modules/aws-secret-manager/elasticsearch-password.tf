resource "aws_secretsmanager_secret" "elastic_user" {
  name = "eck/elasticsearch/elastic-password"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "elastic_user" {
  secret_id = aws_secretsmanager_secret.elastic_user.id

  secret_string = jsonencode({
    username = "elastic"
    password = var.elastic_password
  })
}