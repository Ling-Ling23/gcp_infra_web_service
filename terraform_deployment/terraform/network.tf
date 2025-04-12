#VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project_id}-network"
  auto_create_subnetworks = false
}

# Crestes public and private subnets
resource "google_compute_subnetwork" "public_subnet" {
  name          = "${var.project_id}-public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.project_id}-private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

# Creates a Cloud Router for the VPC
resource "google_compute_router" "nat_router" {
  name    = "${var.project_id}-nat-router"
  network = google_compute_network.vpc_network.name
  region  = var.region
}

# Configures NAT for the Cloud Router to allow instances in private subnets to access the internet
resource "google_compute_router_nat" "nat" {
  name                               = "${var.project_id}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Allow Internal Traffic
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.project_id}-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/16"]
}

# Allow SSH Traffic
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.project_id}-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Allow HTTP Traffic and HTTPS Traffic
resource "google_compute_firewall" "allow_http" {
  name    = "${var.project_id}-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "${var.project_id}-allow-https"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}