resource "kubernetes_deployment_v1" "api" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels    = { app = "api" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "api" }
    }

    template {
      metadata {
        labels = { app = "api" }
      }

      spec {
        container {
          name              = "cstrader"
          image             = "cstrader:latest"
          image_pull_policy = "Never"
          command = ["/bin/sh", "-c"]
          args    = ["cd /app && poetry run uvicorn backend.src.main:app --host 0.0.0.0 --port 8000"]

          port {
            container_port = 8000
          }

          env {
            name  = "PYTHONPATH"
            value = "/app"
          }

          env_from {
            secret_ref {
              name = kubernetes_secret_v1.cstrader-env.metadata[0].name
            }
          }

          resources {
            requests = { cpu = "250m", memory = "128Mi" }
            limits   = { cpu = "500m", memory = "512Mi" }
          }
        }
      }
    }
  }
  
  depends_on = [
    kubernetes_secret_v1.cstrader-env,
    kubernetes_stateful_set_v1.database
  ]
}