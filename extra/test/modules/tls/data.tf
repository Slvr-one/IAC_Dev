
#oidc--   ##to manage permissions apps in Kubernetes
data "tls_certificate" "eks" {
  url = var.oidc_issuer
}