
# install argocd 
resource "helm_release" "argocd" {
  name = "argo-cd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.16.10"
  create_namespace = true
  cleanup_on_fail  = true

  # values = [
  #   "${file("argo/values-override.yaml")}"
  #   file("argo/values-override.yaml") // Argo CD app responsible for the cluster management
  # ]
  # depends_on = [
  #   kubectl_manifest.argocd
  # ]
}

# resource "helm_release" "kubewatch" {
#   name       = "kubewatch"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "kubewatch"

#   values = [
#     file("${path.module}/kubewatch-values.yaml")
#   ]

#   set_sensitive {
#     name  = "slack.token"
#     value = var.slack_app_token
#   }
# }