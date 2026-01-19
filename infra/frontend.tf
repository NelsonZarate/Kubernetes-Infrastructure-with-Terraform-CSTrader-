#configuração Nginx personalizada
resource "kubernetes_config_map_v1" "nginx_conf" {
  metadata {
    name      = "nginx-conf"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
  }

  data = {
    "app.conf" = <<EOF
server {
    listen       3000;
    listen  [::]:3000;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri $uri/ /index.html;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location /api/ {
        # CORREÇÃO: Usa o namespace dinâmico (app) em vez de 'default'
        proxy_pass http://api.${kubernetes_namespace_v1.app.metadata[0].name}:8000;
        
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        add_header 'Access-Control-Allow-Origin' 'http://localhost:3000' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, PUT, DELETE' always;
        add_header 'Access-Control-Allow-Headers' 'Origin, Content-Type, Accept, Authorization' always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;

        if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain; charset=UTF-8';
            add_header 'Content-Length' 0;
            return 204;
        }
    }
}
EOF
  }
}

resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name              = "cstrader-frontend"
          image             = "cstrader-frontend:latest"
          image_pull_policy = "Never"

          port {
            container_port = 3000
          }

          volume_mount {
            name       = "nginx-config-volume"
            mount_path = "/etc/nginx/conf.d/"
          }
        }

        volume {
          name = "nginx-config-volume"
          config_map {
            name = kubernetes_config_map_v1.nginx_conf.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map_v1.nginx_conf,
    kubernetes_service_v1.api,
    kubernetes_service_v1.database,
    null_resource.docker_build_load
    ]
}