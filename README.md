This repository contains the infrastructure and deployment configuration for a web service application in GCP. It leverages Terraform for infrastructure provisioning, Kubernetes for container orchestration, and Google Cloud Platform (GCP) as the cloud provider. The application is deployed using a combination of Kubernetes resources and Helm charts.

## Features
Infrastructure as Code (IaC):
- Terraform is used to provision GCP resources, including Kubernetes clusters and static IP addresses.
- Kubernetes Deployment:
- Kubernetes manifests are defined for deploying the gRPC service.
- Includes configurations for deployments, services, secrets, and resource limits.
- GitHub Container Registry (GHCR):
- Docker images are built and pushed to GHCR.
- Kubernetes uses a secret to pull images securely from GHCR.
- Helm Integration: Helm is configured for managing Kubernetes resources.


## Prerequisites
- Google Cloud Platform (GCP):
- A GCP project with billing enabled.
- A service account with the necessary permissions.
- Terraform: Install Terraform (v1.10.4 or later).
- Kubernetes: A Kubernetes cluster running on GCP (GKE). kubectl configured to access the cluster.
- Docker: Docker installed for building and pushing images.
- GitHub Personal Access Token (PAT): A PAT with read:packages and write:packages permissions for GHCR.

## Setup Instructions
- GCP account
- Terraform Cloud account
- Fork of repository


# GCP

Create new Project

Create credentials for the terraform cloud user. Navigate to IAM & Admin/Service Accounts. Create new Service account e.g. terraform, assign it Owner priviledges. Navigate again to Service Accounts and select your newly created account. From there go to KEYS and create new private key. Make sure to select JSON Download the key to your local. Important Use following command to base64 encode it. Important

  cat gcp-credential.json | tr -s '\n' ' ' | base64

    Important Enable APIs for GKE and Cloud Resource Manager Important

Manually create account in google cloud platform
1. Create a Service Account
	• Go to the Google Cloud Console.
	• Navigate to IAM & Admin > Service Accounts.
	• Click Create Service Account.
	• Provide a name and description for the service account, then click Create and Continue.
2. Assign Roles
	• Assign the necessary role:
		○ Owner (for full access)
	• Click Continue and then Done.
3. Generate a Key
	• Find the service account you just created in the list.
	• Click the three dots next to it and select Manage Keys.
	• Click Add Key > Create New Key.
	• Choose JSON as the key type and click Create.
	• A JSON file containing your credentials will be downloaded.


# Terraform Cloud

Steps to Use Terraform Cloud as Your Backend
1. Create a Terraform Cloud Account
	1. Go to Terraform Cloud and create an account if you don’t already have one.
	2. Create a new organization in Terraform Cloud.

2. Create a Workspace in Terraform Cloud
	1. In your Terraform Cloud organization, create a new workspace.
Choose the CLI-driven workflow (this allows you to run Terraform commands locally while storing the state in Terraform Cloud).![obrazek](https://github.com/user-attachments/assets/cc3f8929-1405-467a-8f9a-9526d22f6837)



# GitHub

    Navigate to your profile / Developer settings
    Select Personal access tokens / Tokens (classic)
    Generate new token
    Go back to your forked repo and add following repository secrets and variables

> [!NOTE]
> Terraform variables in GitHub actions are loaded from GitHub secrets!
![alt text](image.png)

## Configure Terraform Variables (OPTIONAL, IF YOU DON'T WANT TO BUILD INFRA WITH GH ACTIONS)
Update the variables.tf file or provide a terraform.tfvars file with the following variables:

project_id: Your GCP project ID.
region: The GCP region (e.g., us-central1).
google_credentials: Base64-encoded GCP service account key.
github_username: Your GitHub username.
github_email: Your GitHub email.
github_token: Your GitHub Personal Access Token.
MongoDB credentials (mongodb_root_password, mongodb_username, mongodb_password, mongodb_database).

## Deploy Infrastructure
Run the following commands to provision the infrastructure:

    Enable Github actions in the Forked repo
    Run Build Image and Deploy Infra
