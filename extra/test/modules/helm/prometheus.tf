
# # install prometheus 
# resource "helm_release" "prometheus" {
#   name = "kube-prometheus-stack"

#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   namespace        = "prometheus"
#   version          = "43.2.0"
#   create_namespace = true
#   cleanup_on_fail  = true

# #   set {
# #     name  = "server.ingress.enabled"
# #     value = true
# #   }
#   # values = [
#   #   "${file("argo/values-override.yaml")}"
#   #   file("argo/values-override.yaml") // Argo CD app responsible for the cluster management
#   # ]
#   depends_on = [
#     var.node_group //module.eks.aws_eks_node_group.main
#   ]
# }