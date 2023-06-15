# #argo ns file--
# data "kubectl_file_documents" "namespace" {
#   content = file("argo/namespace.yaml")
# }

# #argo crd install file--
# data "kubectl_file_documents" "argocd" {
#   content = file("argo/crds.yaml")
# }

# #kubectl apply--

# resource "kubectl_manifest" "namespace" {
#   count              = length(data.kubectl_file_documents.namespace.documents)
#   yaml_body          = element(data.kubectl_file_documents.namespace.documents, count.index)
#   override_namespace = "argocd"
# }

# resource "kubectl_manifest" "argocd" {
#   depends_on = [
#     kubectl_manifest.namespace,
#   ]
#   count              = length(data.kubectl_file_documents.argocd.documents)
#   yaml_body          = element(data.kubectl_file_documents.argocd.documents, count.index)
#   override_namespace = "argocd"
# }