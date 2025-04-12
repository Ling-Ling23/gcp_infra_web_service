#resource "kubernetes_secret" "haproxy_cert" {
#  metadata {
#    name      = "haproxy-cert"
#    namespace = "default"
#  }
#  data = {
#    "haproxy.pem" = file("${path.module}/cert/haproxy.pem")
#  }
#}

resource "kubernetes_config_map" "haproxy_config" {
  metadata {
    name      = "haproxy-config"
    namespace = "default"
  }
  data = {
    "haproxy.cfg" = <<-EOF
      global
        log stdout format raw local0
        log 127.0.0.1 local0 debug
        maxconn 4000
        daemon
      defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000ms
        timeout client  50000ms
        timeout server  50000ms
      frontend http_front
        bind *:8080 #ssl crt /usr/local/etc/haproxy/haproxy.pem
        default_backend http_back
        acl forbidden_methods method DELETE PATCH OPTIONS
        http-request deny if forbidden_methods
        #http-request deny method DELETE
        #http-request deny method PATCH
        #http-request deny method OPTIONS
        #http-request deny method POST
        #http-request deny if { req.body_size gt 1048576 }  # Limit request body size to 1MB
        #http-response set-header X-Content-Type-Options nosniff
        #http-response set-header X-Frame-Options DENY
        #http-response set-header X-XSS-Protection 1;mode=block
        #http-response set-header Strict-Transport-Security max-age=31536000;includeSubDomains;preload
        #rate limiting
        #stick-table type ip size 1m expire 10m store http_req_rate(10s)
        #acl rate_abuse src_http_req_rate(http_front) gt 100
        #http-request deny if rate_abuse
      backend http_back
        balance roundrobin
        server app1 service-slim.default.svc.cluster.local:5000 check
    EOF
  }
}

resource "kubernetes_deployment" "haproxy" {
  metadata {
    name      = "haproxy"
    namespace = "default"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "haproxy"
      }
    }
    template {
      metadata {
        labels = {
          app = "haproxy"
        }
        annotations = {
          configmap-hash = "${base64sha256(kubernetes_config_map.haproxy_config.data["haproxy.cfg"])}"
          #secret-hash    = "${base64sha256(kubernetes_secret.haproxy_cert.data["haproxy.pem"])}"
        }
      }
      spec {
        container {
          name  = "haproxy"
          image = "haproxy:latest"
          port {
            container_port = 8080
          }
          volume_mount {
            name       = "haproxy-config"
            mount_path = "/usr/local/etc/haproxy/haproxy.cfg"
            sub_path   = "haproxy.cfg"
          }
          #volume_mount {
          #  name       = "haproxy-cert"
          #  mount_path = "/usr/local/etc/haproxy/haproxy.pem"
          #  sub_path   = "haproxy.pem"
          #}
        }
        volume {
          name = "haproxy-config"
          config_map {
            name = kubernetes_config_map.haproxy_config.metadata[0].name
          }
        }
        #volume {
        #  name = "haproxy-cert"
        #  secret {
        #    secret_name = kubernetes_secret.haproxy_cert.metadata[0].name
        #  }
        #}
      }
    }
  }
  timeouts {
    create = "2m"
    update = "2m"
    delete = "2m"
  }
}

resource "kubernetes_service" "haproxy" {
  metadata {
    name      = "haproxy"
    namespace = "default"
  }
  spec {
    selector = {
      app = "haproxy"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}