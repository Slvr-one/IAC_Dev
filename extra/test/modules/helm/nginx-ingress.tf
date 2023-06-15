# resource "helm_release" "nginx_ingress" {
#   name = "ingress-nginx"

#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace        = "nginx"
#   version          = "4.4.0"
#   create_namespace = true
#   cleanup_on_fail            = true

#   set {
#     name  = "service.type"
#     value = "ClusterIP"
#   }
# }