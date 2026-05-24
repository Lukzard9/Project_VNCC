resource "kubernetes_namespace" "envs" {
  for_each = var.environments

  metadata {
    name = "myapp-${each.key}"
  }
}

module "nginx_infrastructure" {
  source   = "./modules/web-app"
  
  for_each = var.environments

  namespace   = kubernetes_namespace.envs[each.key].metadata.0.name
  environment = each.key
  app_name    = "frontend"
  
  replicas    = each.key == "dev" ? 1 : 2
}