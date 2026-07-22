resource "aws_secretsmanager_secret" "alertmanager_slack" {
  name        = "${var.env}/alertmanager"
  description = "Slack webhook for Alertmanager"
}


