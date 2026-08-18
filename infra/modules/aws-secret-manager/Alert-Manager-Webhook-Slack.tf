resource "random_string" "alertmanager_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "alertmanager_slack" {
  name        = "${var.env}/alertmanager-${random_string.alertmanager_suffix.result}"
  description = "Slack webhook for Alertmanager"
  recovery_window_in_days = 7
  tags = {
    Environment = var.env
    ManagedBy   = "Terraform"
    Application = "prometheus-alert-manager"
  }
}



