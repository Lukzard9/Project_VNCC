resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.25"
          name  = "nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
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

          volume_mount {
            name       = "tls-certs"
            mount_path = "/etc/nginx/ssl"
            read_only  = true
          }

          volume_mount {
            name       = "nginx-conf"
            mount_path = "/etc/nginx/conf.d"
          }
        }

        volume {
          name = "config-volume"
          config_map {
            name = kubernetes_config_map.app_config.metadata.0.name
          }
        }

        volume {
          name = "persistent-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.data_pvc.metadata.0.name
          }
        }

        volume {
          name = "tls-certs"
          secret {
            secret_name = kubernetes_secret.tls_secret.metadata.0.name
          }
        }

        volume {
          name = "nginx-conf"
          config_map {
            name = kubernetes_config_map.app_config.metadata.0.name
            items {
              key  = "default.conf"
              path = "default.conf"
            }
          }
        }
      }
    }
  }
}
