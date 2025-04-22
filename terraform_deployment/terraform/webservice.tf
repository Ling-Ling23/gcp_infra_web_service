resource "kubernetes_secret" "ghcr_secret" {
  metadata {
    name      = "ghcr-secret"
    namespace = "default"
  }
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          auth     = base64encode("${var.github_username}:${var.github_token}")
          username = var.github_username
          password = var.github_token
          email    = var.github_email
        }
      }
    })
  }
  type = "kubernetes.io/dockerconfigjson"
}

#resource "google_compute_address" "my_static_ip" {
#  name   = "my-static-ip"
#  region = var.region
#}

resource "kubernetes_deployment" "service_slim" {
  metadata {
    name      = "service-slim"
    namespace = "default"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "service-slim"
      }
    }
    template {
      metadata {
        labels = {
          app = "service-slim"
        }
      }
      spec {
        image_pull_secrets {
          name = "ghcr-secret"
        }
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["service-slim"]
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        container {
          name  = "service-slim"
          image = "ghcr.io/${var.github_owner_lowercase}/service_slim:latest"
          resources {
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "400Mi"
            }
          }
          port {
            container_port = 5000
          }
        }
      }
    }
  }
  timeouts {
    create = "3m"  # Timeout for creating the deployment
    update = "3m"  # Timeout for updating the deployment
  }  
}

resource "kubernetes_service" "service_slim" {
  metadata {
    name      = "service-slim"
    namespace = "default"
  }
  spec {
    selector = {
      app = "service-slim"
    }
    port {
      port        = 5000
      target_port = 5000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "service_slim" {
  metadata {
    name      = "service-slim-hpa"
    namespace = "default"
  }
  spec {
    scale_target_ref {
      kind       = "Deployment"
      name       = kubernetes_deployment.service_slim.metadata[0].name
      api_version = "apps/v1"
    }
    min_replicas = 2  # Ensure minimum replicas are spread across zones
    max_replicas = 5
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 50
        }
      }
    }
    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type               = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}