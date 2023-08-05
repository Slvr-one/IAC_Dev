# resource "helm_repository" "eks" {
#   name  = "eks"
#   url   = "https://aws.github.io/eks-charts"
# }

# resource "helm_release" "jenkins" {
# #   provider = helm.primary
#   name       = "jenkins"

#   repository = "https://charts.jenkins.io/" #"${helm_repository.eks.metadata.0.name}"
#   chart      = "jenkins"
#   namespace        = "ci"
#   version          = "4.2.18"
# #   version          = "3.1.15"
#   create_namespace = true
#   cleanup_on_fail  = true
#   timeout    = 300

# #   set_sensitive {
# #     name  = "controller.adminUser"
# #     value = var.jenkins_admin_user
# #   }

# #   set_sensitive {
# #     name  = "controller.adminPassword"
# #     value = var.jenkins_admin_password
# #   }

# #   values = [
# #     # "${file("jenkins/values-override.yaml")}"
# #     file("manifests/jenkins/values-override.yaml")
# #   ]
# }

# #########################
