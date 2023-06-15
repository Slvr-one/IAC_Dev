output "cert_fingerprint" {
  value = data.tls_certificate.eks.certificates[0].sha1_fingerprint
}