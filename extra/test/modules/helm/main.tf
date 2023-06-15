# resource "helm_repository" "eks" {
#   name  = "eks"
#   url   = "https://aws.github.io/eks-charts"
# }

# resource "helm_release" "kube-prometheus-stack" {
#   name       = "kube-prometheus-stack"
#   repository = "${helm_repository.eks.metadata.0.name}"
#   chart      = "kube-prometheus-stack"

#   set {
#     name  = "grafana.enabled"
#     value = true
#   }
# }


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