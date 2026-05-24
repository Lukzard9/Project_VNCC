resource "kubernetes_service" "nginx_svc" {
  metadata {
    name = "nginx-service"
  }
  spec {
    
    selector = kubernetes_deployment.nginx.metadata.0.labels

    port {
      port        = 80
      target_port = 80
      node_port   = 30080 
    }
    
    type = "NodePort"
  }
}
