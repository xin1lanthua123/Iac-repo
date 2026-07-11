locals {
  oidc_host = replace(var.oidc_provider_url, "https://", "")
}