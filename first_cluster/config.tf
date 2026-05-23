resource "kubernetes_secret" "app_secret" {
  metadata {
    name = "db-credentials"
  }
  data = {
    "password" = "secret-password-123" 
  }
  type = "Opaque"
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name = "app-settings"
  }
  data = {
    "config.json" = "{\"environment\": \"development\"}"
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

  lifecycle {
    prevent_destroy = false
  }
}
