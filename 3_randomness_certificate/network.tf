resource "kubernetes_service" "nginx_svc" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = kubernetes_deployment.nginx.metadata.0.labels

    port {
      name        = "http"
      port        = 80
      target_port = 80
      node_port   = 30080 
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
      node_port   = 30443 # Esposta sul nodo per HTTPS
    }
    
    type = "NodePort"
  }
}