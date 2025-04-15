terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ling_ling23"

    workspaces {
      name = "grpc_test"
    }
  }
}