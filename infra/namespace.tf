# --- Namespace ---
resource "kubernetes_namespace_v1" "app" {
  metadata {
    name = "app"
  }
}

# --- Database Secret (Partilhado) ---
resource "kubernetes_secret_v1" "cstrader-env" {
  metadata {
    name      = "cstrader-env"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
  }

  # O Terraform Provider já codifica isto automaticamente!
  data = {
    username                    = var.database_username
    password                    = var.database_password
    dbname                      = var.database_name
    SECRET_KEY                  = var.secret_key
    ALGORITHM                   = var.algorithm
    ACCESS_TOKEN_EXPIRE_MINUTES = tostring(var.access_token_expire_minutes)
    DATABASE_DRIVER             = var.database_driver
    DATABASE_USERNAME           = var.database_username
    DATABASE_PASSWORD           = var.database_password
    DATABASE_HOST               = var.database_host
    DATABASE_PORT               = tostring(var.database_port)
    DATABASE_NAME               = var.database_name
    ADMIN_EMAIL                 = var.admin_email
    ADMIN_PASSWORD              = var.admin_password
    ADMIN_NAME                  = var.admin_name
    DATABASE_URL                = "postgresql://${var.database_username}:${var.database_password}@${var.database_host}:${var.database_port}/${var.database_name}"
  }

  type = "Opaque"
}