# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_id
# }

# data "aws_availability_zones" "available" {
#   # name = aws_availability_zones.available.name
# }

resource "kubernetes_deployment" "jenkins" {
  metadata {
    name = "jenkins-depl"
    labels = {
      app = "bookmaker"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "bookmaker"
        name  = "bookmaker"
      }
    }

    template {
      metadata {
        labels = {
          app = "bookmaker"
        }
      }

      spec {
        container {
          image = "${var.image}:${var.imageTag}"
          name  = "bookmaker"

          resources {
            limits {
              cpu    = "1000m"
              memory = "1500Mi"
            }
            requests {
              cpu    = "250m"
              memory = "500Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "app"
  }
  spec {
    selector = {
      app = "bookmaker"
    }
    port {
      port        = var.servicePort
      target_port = var.servicePort
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "app_ingress" {
  metadata {
    name = "app-ingress"
  }

  spec {
    backend {
      service_name = "myapp-1"
      service_port = 8080
    }

    rule {
      http {
        path {
          backend {
            service_name = "myapp-1"
            service_port = 8080
          }

          path = "/app1/*"
        }

        path {
          backend {
            service_name = "myapp-2"
            service_port = 8080
          }

          path = "/app2/*"
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name = "myapp-1"
  }
  spec {
    selector = {
      app = kubernetes_pod.app.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_service_v1" "app2" {
  metadata {
    name = "myapp-2"
  }
  spec {
    selector = {
      app = kubernetes_pod.app2.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "NodePort"
  }
}

# resource "kubernetes_service" "example" {
#   metadata {
#     name = "ingress-service"
#   }
#   spec {
#     port {
#       port        = 80
#       target_port = 80
#       protocol    = "TCP"
#     }
#     type = "NodePort"
#   }
# }

# resource "kubernetes_ingress" "example" {
#   wait_for_load_balancer = true
#   metadata {
#     name = "example"
#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#     }
#   }
#   spec {
#     rule {
#       http {
#         path {
#           path = "/*"
#           backend {
#             service_name = kubernetes_service.example.metadata.0.name
#             service_port = 80
#           }
#         }
#       }
#     }
#   }
# }
