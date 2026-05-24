resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "app_secret" {
  metadata {
    name = "db-credentials"
  }
  data = {
    "password" = random_password.db_password.result 
  }
  type = "Opaque"
}

resource "tls_private_key" "nginx_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "nginx_cert" {
  private_key_pem = tls_private_key.nginx_key.private_key_pem

  subject {
    common_name  = "localhost"
    organization = "Demo Terraform IaC"
  }

  validity_period_hours = 8760 # 1 anno
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "kubernetes_secret" "tls_secret" {
  metadata {
    name = "nginx-tls"
  }
  data = {
    "tls.crt" = tls_self_signed_cert.nginx_cert.cert_pem
    "tls.key" = tls_private_key.nginx_key.private_key_pem
  }
  type = "kubernetes.io/tls"
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name = "app-settings"
  }
  data = {
    "config.json" = "{\"environment\": \"development\"}"
    # Iniettiamo una configurazione base di Nginx per fargli leggere i certificati
    "default.conf" = <<EOF
server {
    listen 80;
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/nginx/ssl/tls.crt;
    ssl_certificate_key /etc/nginx/ssl/tls.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
EOF
  }
}

resource "kubernetes_persistent_volume_claim" "data_pvc" {
  wait_until_bound = false
  metadata {
    name = "data-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "100Mi"
      }
    }
    storage_class_name = "standard" 
  }
}
