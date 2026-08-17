resource "aws_secretsmanager_secret" "argocd_slack" {
  name        = "${var.env}/argocd"
  description = "Slack credentials for ArgoCD notifications"
  recovery_window_in_days = 7

  tags = {
    Environment = "${var.env}"
    Application = "argocd"
    ManagedBy   = "terraform"
  }
}


