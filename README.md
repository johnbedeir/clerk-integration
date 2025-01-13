# Clerk-API-Wrapper: Deployment Guide

<img src=imgs/cover.png>

## Overview

The **Clerk-API-Wrapper** is a comprehensive application that integrates with Clerk.io to manage product data efficiently. The application is designed to leverage modern DevOps practices, ensuring a secure and scalable infrastructure. Using Terraform, Terragrunt, and Kubernetes, the deployment automates secrets management, infrastructure creation, and application provisioning.

### Key Features:

- **Secrets Management**: Terraform creates secrets in AWS Secrets Manager based on the `terraform.tfvars` file. These secrets are automatically fetched by Kubernetes using ClusterSecretStore and ExternalSecrets to create Kubernetes secrets for application deployment.
- **Infrastructure as Code**: The infrastructure is defined using Terraform and managed with Terragrunt for efficient multi-environment deployments.
- **Modern Deployment Practices**: Supports both Kubernetes manifests and Helm charts for deployment, providing flexibility and scalability.

### Tools Required:

To run this project, ensure the following tools are installed:

- **Terragrunt**: For managing Terraform configurations `dev` and `prod` environment.
- **Terraform**: For defining infrastructure as code.
- **AWS CLI**: For managing AWS resources and EKS clusters.
- **Kubernetes CLI (kubectl)**: For interacting with Kubernetes clusters.
- **Docker**: For building container images.

---

## Deployment Steps

### 1. Pre-Build Setup

1. **Create `terraform.tfvars`**:
   Navigate to `infrastructure/modules` directory and create a `terraform.tfvars` file with the following format:

   ```terraform
   clerk_public_key  = "n4UsgwDE3uhUr9FRd3B7H4ygzDv5d0rX"
   clerk_private_key = "es78AlQ9YAYOPjV24lnC1Xh9UmJYaGc8"
   clerk_api_url = "https://api.clerk.io/v2/product/list?key="
   ```

   > Obtain the `Public API Key` and `Private API Key` from the Clerk dashboard under `Settings > API Keys`.

2. **Secrets Management**:
   Terraform will create secrets in AWS Secrets Manager using the values from `terraform.tfvars`. These secrets will be fetched into Kubernetes as environment variables via ClusterSecretStore and ExternalSecrets.

---

### 2. Build Infrastructure

1. Navigate to the `infrastructure` directory.
2. Run the following command:

   ```sh
   terragrunt run-all apply
   ```

   > This will provision the necessary AWS resources, including the EKS cluster, VPC, and Secrets Manager entries.

---

### 4. Post-Build Steps

1. **Update kubeconfig**:

   Run the following command to configure `kubectl` for the EKS cluster:

   ```sh
   aws eks update-kubeconfig --name cluster-1-dev --region eu-central-1
   ```

   <img src=imgs/eks.png>

   Encode the kubeconfig:

   ```
   cat .kube/config | base64
   ```

   Copy the output to github secrets.

### 4. Continuous Integration and Continuous Deployment

Make sure you run the following script to add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to store aws credentials in github secrets.

Navigate to the [Application GitHub Repository](https://github.com/johnbedeir/clerk-integration), go to the `Actions` tab, and run the latest workflow to ensure the Docker image is built and pushed to AWS ECR.

> Commit any recent updates before triggering the workflow.

    <img src=imgs/ecr.png>

Once the workflow is successfully done the `Continuous Deployment` will run automatically.

---

### 5. Application Deployment

#### Option 1: Deploy via Kubernetes Manifests

1. Create the namespace:

   ```sh
   kubectl create ns dev-clerk-app
   ```

2. Deploy the application:

   ```sh
   kubectl apply -n dev-clerk-app -f k8s/eks/
   ```

   > This deploys the application, including Deployment, Service, and ExternalSecrets.

#### Option 2: Deploy via Helm Chart

1. Navigate to the [Chart Repository](https://github.com/johnbedeir/clerk-app-chart).
2. Follow the steps in the `README` to deploy the application using Helm.

---

### 6. Configuring DNS Records

1. **Fetch Load Balancer URLs**:
   Use the following commands to retrieve the LoadBalancer URLs for various services:

   - **Application Service**:

     ```sh
     kubectl get svc clerk-app-service -n dev-clerk-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
     ```

   - **Ingress Controller**:

     ```sh
     kubectl get svc nginx-ingress-ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
     ```

   - **ArgoCD**:
     ```sh
     kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
     ```

2. **Update DNS Records**:
   Add the following CNAME records in your domain’s DNS zone editor:

   | Service      | CNAME                       |
   | ------------ | --------------------------- |
   | Application  | `clerk.johnydev.com`        |
   | Prometheus   | `prometheus.johnydev.com`   |
   | AlertManager | `alertmanager.johnydev.com` |
   | Grafana      | `grafana.johnydev.com`      |
   | ArgoCD       | `argocd.johnydev.com`       |

    <img src=imgs/cpanel.png>

### 7. Accessing Applications

- **Prometheus**:
  Navigate to `prometheus.johnydev.com`.

  <img src=imgs/prometheus.png>

- **AlertManager**:
  Navigate to `alertmanager.johnydev.com`.

  <img src=imgs/alertmanager.png>

- **Clerk Application**:
  Navigate to `clerk.johnydev.com`.

  <img src=imgs/clerk.png>

  Verify the data feed at `clerk.johnydev.com/feeds/clerk.json`. Copy this URL into the Clerk.io Data Sync settings.

  <img src=imgs/data-sync.png>

- **ArgoCD**:
  Navigate to `argocd.johnydev.com`.

  Login Credentials:

  - Username: `admin`
  - Password: Retrieve using:
    ```sh
    kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
    ```

  Add a new application via GitHub or Helm Chart as required.

  <img src=imgs/argocd.png>

- **Grafana**:
  Navigate to `grafana.johnydev.com`.

  Login Credentials:

  - Username: `admin`
  - Password: `admin`

  Navigate to Dashboards and select the preferred dashboard.

  <img src=imgs/grafana.png>
