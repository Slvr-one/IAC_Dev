
# install argocd 
resource "helm_release" "argocd" {
  name = "argo-cd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.16.12"
  create_namespace = true
  cleanup_on_fail  = true
  # reset_values               = true

  values = [
    file("./manifests/argo/values-override.yaml") // Argo CD app responsible for the cluster management
  ]
}
