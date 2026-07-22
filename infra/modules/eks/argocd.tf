# helm install argocd -n argocd --create-namespace argo/argo-cd --version 7.3.11 -f terraform/values/argocd.yaml
resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "9.4.0"

  values = [file("values/argocd-values-9.4.0.yaml")]

  depends_on = [module.eks]
}
resource "helm_release" "updater" {
  name = "updater"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = true
  version          = "1.2.4"

  values = [file("values/argocd-image-updater-values-1.2.4.yaml")]

  depends_on = [helm_release.argocd]
}

