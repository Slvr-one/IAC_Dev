# allow granting iam premmissions based on the seviceAcount used by the pod
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.fingerprint] #data.tls_certificate.eks.certificates[0].sha1_fingerprint
  url             = var.oidc_issuer   #aws_eks_cluster.victor.identity[0].oidc[0].issuer
}