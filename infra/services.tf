resource "kubernetes_service_v1" "database" {
  metadata {
    name      = "database"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
  }
  spec {
    selector = {
      app = "database"
    }
    port {
      port        = 5432
      target_port = 5432
    }
    type = "ClusterIP"
  }
}

# --- Service da API ---
# Permite que o Frontend encontre a API pelo nome "api"
resource "kubernetes_service_v1" "api" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
  }
  spec {
    selector = {
      app = "api"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "ClusterIP" # Acessível apenas dentro do cluster
  }
}

# --- Service do Frontend ---
# Expõe o frontend (Vamos usar port-forward depois)
resource "kubernetes_service_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "ClusterIP" 
  }
}