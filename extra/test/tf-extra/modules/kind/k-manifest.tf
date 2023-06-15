
# #kubectl eks

# //install olm
# data "kubectl_file_documents" "crds" {
#   content = file("olm/crds.yaml")
# }

# resource "kubectl_manifest" "crds_apply" {
#   for_each          = data.kubectl_file_documents.crds.manifests
#   yaml_body         = each.value
#   wait              = true
#   server_side_apply = true
# }

# data "kubectl_file_documents" "olm" {
#   content = file("olm/olm.yaml")
# }

# resource "kubectl_manifest" "olm_apply" {
#   depends_on = [data.kubectl_file_documents.crds]
#   for_each   = data.kubectl_file_documents.olm.manifests
#   yaml_body  = each.value
# }

# #kubectl gke

# data "kubectl_file_documents" "namespace" {
#   content = file("../manifests/argocd/namespace.yaml")
# }

# data "kubectl_file_documents" "argocd" {
#   content = file("../manifests/argocd/install.yaml")
# }

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
