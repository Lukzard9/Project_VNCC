resource "local_file" "app_env_file" {
  filename = "${path.module}/.env"
  
  content = <<-EOT
    APP_ENV=development
    
    DB_PASSWORD=${random_password.db_password.result}
    
    KIND_API_ENDPOINT=${kind_cluster.local_cluster.endpoint}
    
    APP_HTTP_URL=http://localhost:30080
    APP_HTTPS_URL=https://localhost:30443
  EOT
}