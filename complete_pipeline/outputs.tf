data "kubernetes_namespace" "default" {
  metadata {
    name = "default"
  }
  depends_on = [kind_cluster.local_cluster]
}

# --- OUTPUTS ---
output "cluster_uid" {
  description = "L'UID univoco del cluster Kind (estratto tramite Data Source)"
  value       = data.kubernetes_namespace.default.metadata[0].uid
}

output "nginx_access_port" {
  description = "La porta NodePort per accedere a Nginx dal browser"
  value       = kubernetes_service.nginx_svc.spec[0].port[0].node_port
}