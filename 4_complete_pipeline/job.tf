resource "kubernetes_job" "db_migration" {
  metadata {
    name = "db-migration-job"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "migrator"
          image   = "busybox:latest"
          command = ["sh", "-c", "echo 'Esecuzione migrazione DB in corso...'; sleep 15; echo 'Migrazione completata'"]
        }
        restart_policy = "Never"
      }
    }
  }
  
  wait_for_completion = true
  
  timeouts {
    create = "1m"
  }
}