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

# Setup Instructions
- GCP account
- Terraform Cloud account
- Fork of repository


## GCP

Create new Project

Create credentials for the terraform cloud user. Navigate to IAM & Admin/Service Accounts. Create new Service account e.g. terraform, assign it Owner priviledges. Navigate again to Service Accounts and select your newly created account. From there go to KEYS and create new private key. Make sure to select JSON Download the key to your local. Important Use following command to base64 encode it. Important

  cat gcp-credential.json | tr -s '\n' ' ' | base64



Manually create account in google cloud platform
1. Create a Service Account
	1. Go to the Google Cloud Console.
	2. Navigate to IAM & Admin > Service Accounts.
	3. Click Create Service Account.
	4. Provide a name and description for the service account, then click Create and Continue.
2. Assign Roles
	1. Assign the necessary role: Owner (for full access)
	2. Click Continue and then Done.
3. Generate a Key
	1. Find the service account you just created in the list.
	2. Click the three dots next to it and select Manage Keys.
	3. Click Add Key > Create New Key.
	4. Choose JSON as the key type and click Create.
	5. A JSON file containing your credentials will be downloaded. base64 encode it
    	at gcp-credential.json | tr -s '\n' ' ' | base64
 	> [!IMPORTANT]
	> Enable APIs for GKE and Cloud Resource Manager
    

# Terraform Cloud

Steps to Use Terraform Cloud as Your Backend
1. Create a Terraform Cloud Account
	1. Go to Terraform Cloud and create an account if you don’t already have one.
	2. Create a new organization in Terraform Cloud.

2. Create a Workspace in Terraform Cloud
	1. In your Terraform Cloud organization, create a new workspace. Choose the CLI-driven workflow (this allows you to run Terraform commands locally while storing the state in Terraform Cloud).


# GitHub

    Navigate to your profile / Developer settings
    Select Personal access tokens / Tokens (classic)
    Generate new token
    Go back to your forked repo and add following repository secrets and variables

> [!NOTE]
> Terraform variables in GitHub actions are loaded from GitHub secrets!
![alt text](image.png)

## Configure Terraform Variables (GH Actions will recreate them when deploy via Actions)
Update the variables.tf file or provide a terraform.tfvars file with the following variables:

- project_id: Your GCP project ID.
- region: The GCP region (e.g., us-central1).
- google_credentials: Base64-encoded GCP service account key.
- github_username: Your GitHub username.
- github_email: Your GitHub email.
- github_token: Your GitHub Personal Access Token.
- MongoDB credentials (mongodb_root_password, mongodb_username, mongodb_password, mongodb_database).

## Deploy Infrastructure
Run the following in GitHub Actions to provision the infrastructure:

    Enable Github actions in the Forked repo
    Run Build Image and Deploy Infra




# RESULT
![obrazek](https://github.com/user-attachments/assets/27026200-c207-4b20-8aa1-16e3ca007cf4)

![obrazek](https://github.com/user-attachments/assets/3732b9db-480b-46c8-8fa0-700a4d3d30d6)

![obrazek](https://github.com/user-attachments/assets/db39fd99-aca6-424c-9fe3-0ab862ca4d8a)

![obrazek](https://github.com/user-attachments/assets/c1a7d098-40fb-4fa1-80ea-144875faf21a)




