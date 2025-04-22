resource "kubernetes_config_map" "mongo_init_script" {
  metadata {
    name      = "mongo-init-script"
    namespace = "default"
  }
  data = {
    "init-mongo.js" = file("${path.module}/config_maps/init-mongo.js")
  }
}

#resource "kubernetes_persistent_volume_claim" "mongodb_data" {
#  metadata {
#    name      = "mongodb-data"
#    namespace = "default"
#  }
#
#  spec {
#    storage_class_name = "standard"
#    access_modes = ["ReadWriteOnce"]
#    resources {
#      requests = {
#        storage = "8Gi"
#      }
#    }
#  }
#
#  depends_on = [google_container_cluster.primary]
#}

resource "helm_release" "mongodb" {
  name       = "mongodb-data"
  #repository = "https://charts.bitnami.com/bitnami"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "mongodb"
  version    = "16.4.2"
  
  set {
    name  = "auth.rootPassword"
    value = var.mongodb_root_password
  }

  set {
    name  = "auth.username"
    value = var.mongodb_username
  }

  set {
    name  = "auth.password"
    value = var.mongodb_password
  }

  set {
    name  = "auth.database"
    value = var.mongodb_database
  }
  
  set {
    name  = "initdbScriptsConfigMap"
    value = kubernetes_config_map.mongo_init_script.metadata[0].name
  }

  set {
    name  = "persistence.storageClass"
    value = "standard"
  }

  set {
    name  = "persistence.size"
    value = "8Gi"
  }

  #depends_on = [
  #  kubernetes_persistent_volume_claim.mongodb_data,
  #  kubernetes_config_map.mongo_init_script
  #]
}

resource "kubernetes_secret" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = "default"
  }

  data = {
    "datasources.yaml" = <<-EOF
      apiVersion: 1
      datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        url: http://prometheus-kube-prometheus-prometheus.default.svc.cluster.local:9090
        isDefault: true
      - name: Loki
        type: loki
        access: proxy
        url: http://grafana-loki-query-frontend.default.svc.cluster.local:3100
    EOF
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "grafana"
  version    = "11.4.5"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set_sensitive {
    name  = "admin.password"
    value = "admin"
  }

  set {
    name  = "admin.password"
    value = "admin"
  }

  set {
    name  = "adminPassword"
    value = "admin"
  }

  set {
    name  = "datasources.secretName"
    value = kubernetes_secret.grafana_datasources.metadata[0].name
  }
}


resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "kube-prometheus"
  version    = "10.2.5"

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "alertmanager.enabled"
    value = "true"
  }
  set {
    name = "operator.enabled"
    value = "true"
  }
}

resource "helm_release" "grafana-loki" {
  name       = "grafana-loki"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "grafana-loki"
  version    = "4.7.3"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "compactor.enabled"
    value = "false"
  }

  set {
    name  = "compactor.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "compactor.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "compactor.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "compactor.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "distributor.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "distributor.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "distributor.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "distributor.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "gateway.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "gateway.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "gateway.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "gateway.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "ingester.resourcesPreset"
    value = "micro"
  }

  #set {
  #  name  = "ingester.persistence.storageClass"
  #  value = "standard-rwo"  # Ensure this matches your storage class
  #}

  set {
    name  = "ingester.persistence.enabled"
    value = "false"
  }

  set {
    name  = "promtail.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "promtail.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "promtail.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "promtail.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "querier.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "querier.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "querier.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "querier.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "queryFrontend.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "queryFrontend.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "queryFrontend.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "queryFrontend.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "queryScheduler.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "queryScheduler.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "queryScheduler.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "queryScheduler.resources.limits.memory"
    value = "256Mi"
  }
 # set {
 #   name  = "metrics.serviceMonitor.enabled"
 #   value = "true"
 # }
   timeout = 300
}