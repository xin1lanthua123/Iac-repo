output "argocd_secret_arn" {
  value = aws_secretsmanager_secret.argocd_slack.arn
}

output "alertmanager_secret_arn" {
  value = aws_secretsmanager_secret.alertmanager_slack.arn
}

output "github_app_secret_arn" {
  value =  aws_secretsmanager_secret.github_app.arn
}

output "secret_names" {

  value = {

    argocd_slack = aws_secretsmanager_secret.argocd_slack.name
    alertmanager_slack = aws_secretsmanager_secret.alertmanager_slack.name
    github_app =  aws_secretsmanager_secret.github_app.name

  }

}