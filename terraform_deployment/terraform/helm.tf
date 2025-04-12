resource "kubernetes_config_map" "mongo_init_script" {
  metadata {
    name      = "mongo-init-script"
    namespace = "default"
  }
  data = {
    "init-mongo.js" = file("${path.module}/config_maps/init-mongo.js")
  }
}

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
}
