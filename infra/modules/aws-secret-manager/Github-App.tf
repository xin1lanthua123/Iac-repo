resource "aws_secretsmanager_secret" "github_app" {
  name        = "argocd/${var.env}/github-app"
  description = "GitHub App credentials for ArgoCD repository access"

  recovery_window_in_days = 7

  tags = {
    Environment = var.env
    ManagedBy   = "Terraform"
    Application = "argocd"
  }
}