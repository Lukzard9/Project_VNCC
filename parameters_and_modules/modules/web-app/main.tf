# CONFIG
resource "kubernetes_secret" "app_secret" {
  metadata {
    name      = "${var.app_name}-db-credentials"
    namespace = var.namespace
  }
  data = { "password" = "secret-password-123" }
  type = "Opaque"
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "${var.app_name}-settings"
    namespace = var.namespace
  }
  data = { "config.json" = jsonencode({"environment": var.environment}) }
}

resource "kubernetes_persistent_volume_claim" "data_pvc" {
  wait_until_bound = false
  metadata {
    name      = "${var.app_name}-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = { storage = "100Mi" } 
    }
    storage_class_name = "standard"
  }
}

# DEPLOYMENT
resource "kubernetes_deployment" "app_deploy" {
  metadata {
    name      = "${var.app_name}-deployment"
    namespace = var.namespace
    labels    = { app = var.app_name, env = var.environment }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = { app = var.app_name }
    }

    template {
      metadata {
        labels = { app = var.app_name, env = var.environment }
      }
      spec {
        container {
          image = "nginx:1.25"
          name  = var.app_name

          resources {
            limits   = { cpu = "0.5", memory = "512Mi" }
            requests = { cpu = "250m", memory = "50Mi" }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.app_secret.metadata.0.name
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/app/config"
            read_only  = true
          }
          volume_mount {
            name       = "persistent-data"
            mount_path = "/usr/share/nginx/html/data"
          }
        }

        volume {
          name = "config-volume"
          config_map { name = kubernetes_config_map.app_config.metadata.0.name }
        }
        volume {
          name = "persistent-data"
          persistent_volume_claim { claim_name = kubernetes_persistent_volume_claim.data_pvc.metadata.0.name }
        }
      }
    }
  }
}

# SERVICE
resource "kubernetes_service" "app_svc" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = var.namespace
  }
  spec {
    selector = kubernetes_deployment.app_deploy.metadata.0.labels

    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}