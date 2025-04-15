resource "google_container_cluster" "primary" {
  name     = "my-cluster-2"
  location = var.region  # Use region instead of zone
  #location = "us-central1" 
  #location = var.zone
  node_locations = ["us-central1-f", "us-central1-c"]  # Specify the zones , "us-central1-b"

  remove_default_node_pool = true  # Prevent creation of the default node pool
  initial_node_count = 2
#
  node_config {
    machine_type = "n1-standard-2"
    disk_size_gb = 20
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = var.region  # Use region instead of zone
  #location   = "us-central1"  # Use region instead of zone
  #location = var.zone
  node_count = 2

  node_config {
    machine_type = "n1-standard-2"
    disk_size_gb = 20
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

#terraform {
#  backend "gcs" {
#    bucket  = "my-project-aw-test-1-terraform-state-bucket"
#    prefix  = "terraform/state"
#  }
#}

#resource "kubernetes_namespace" "default" {
#  metadata {
#    name = "default"
#  }
#}
