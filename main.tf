resource "tls_private_key" "client_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
resource "tls_private_key" "client_admin" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
resource "tls_self_signed_cert" "client_ca" {
  private_key_pem = tls_private_key.client_ca.private_key_pem
  is_ca_certificate = true
  subject {
    common_name  = "k3s-client-ca"
  }

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

resource "tls_cert_request" "client_admin" {
  private_key_pem = tls_private_key.client_admin.private_key_pem

  subject {
    common_name  = "system:admin"
    organization = "system:masters"
  }
}
resource "tls_locally_signed_cert" "client_admin" {
  cert_request_pem   = tls_cert_request.client_admin.cert_request_pem
  ca_private_key_pem = tls_private_key.client_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.client_ca.cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth"
  ]
}