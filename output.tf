output "client_ca" {
  value = base64encode(tls_self_signed_cert.client_ca.cert_pem)
}
output "client_admin" {
  value = base64encode(tls_locally_signed_cert.client_admin.cert_pem)
}