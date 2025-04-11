variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "github_owner_lowercase" {
  description = "The GitHub repository owner"
  type        = string
}

variable "google_credentials" {
  description = "Base64 encoded Google Cloud credentials"
  type        = string
}

variable "mongodb_root_password" {
  description = "The root password for MongoDB"
  type        = string
}

variable "mongodb_username" {
  description = "The username for MongoDB"
  type        = string
}

variable "mongodb_password" {
  description = "The password for MongoDB"
  type        = string
}

variable "mongodb_database" {
  description = "The database name for MongoDB"
  type        = string
}

#svariable "github_username" {
#s  description = "The GitHub username"
#s  type        = string
#s}

#variable "github_email" {
#  description = "The GitHub email"
#  type        = string
#}
#
#variable "github_token" {
#  description = "The GitHub token"
#  type        = string
#}