resource "aws_secretsmanager_secret" "alertmanager_slack" {
  name        = "${var.env}/alertmanager"
  description = "Slack webhook for Alertmanager"
  recovery_window_in_days = 7
  tags = {
    Environment = var.env
    ManagedBy   = "Terraform"
    Application = "prometheus-alert-manager"
  }
}



