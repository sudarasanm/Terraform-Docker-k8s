# Wobot DevOps Assignment

This project demonstrates a complete CI/CD pipeline for a microservices application on Google Cloud Platform (GCP). It uses Terraform for infrastructure provisioning, Docker for containerization, and Google Kubernetes Engine (GKE) for orchestration.

## 1. Infrastructure as Code with Terraform

The entire infrastructure for this project is managed using Terraform, ensuring a repeatable and version-controlled setup. The Terraform code is organized into modules for better reusability and maintainability.

### 1.1. VPC and Networking

-   **VPC:** A custom Virtual Private Cloud (VPC) is created to provide a secure and isolated network for the application.
-   **Subnet:** A subnet is created within the VPC to host the GKE cluster and other resources.
-   **Firewall Rules:** Firewall rules are configured to allow necessary traffic, such as SSH access for bastion hosts.

*Files:* `terraform/modules/vpc/main.tf`

### 1.2. Google Kubernetes Engine (GKE)

-   **GKE Cluster:** A GKE cluster is provisioned to host the microservices.
-   **Node Pool:** A dedicated node pool is created for the cluster to run the application workloads.

*Files:* `terraform/modules/gke/main.tf`

### 1.3. Compute Instances

-   **Bastion Host:** A bastion host is created for secure access to the GKE cluster and other resources within the VPC.
-   **Utility VM:** A utility VM is provisioned for running administrative tasks and tools.

*Files:* `terraform/modules/compute/main.tf`

### 1.4. IAM and Security

-   **IAM Roles:** IAM roles are configured to follow the principle of least privilege, granting only the necessary permissions to users and service accounts.
-   **Service Accounts:** Dedicated service accounts are used for different components of the application.

*Files:* `terraform/modules/iam/main.tf`

### 1.5. Artifact Registry

-   **Docker Registry:** A private Docker registry is created using Artifact Registry to store and manage the Docker images for the application.

*Files:* `terraform/modules/registry/main.tf`

### 1.6. Terraform Best Practices

-   **Modules:** The Terraform code is organized into reusable modules, as seen in the `terraform/modules` directory.
-   **Validation:** The `terraform validate` command is used to check the syntax and configuration of the Terraform code.
-   **Variable Definitions:** A `tfvars.example` file is provided to show the required variables for running the Terraform code.

## 2. Containerization with Docker

The application is containerized using Docker to ensure consistency across different environments.

### 2.1. Backend Service

-   **Multi-stage Build:** The backend service uses a multi-stage Docker build to create a small and secure image. The first stage builds the Python dependencies, and the final stage copies the built dependencies and the application code.
-   **Non-root User:** The container runs as a non-root user to enhance security.
-   **Optimized Caching:** The Dockerfile is structured to optimize layer caching, which speeds up the build process.

*File:* `services/backend/Dockerfile`

### 2.2. Frontend Service

-   **Nginx Base Image:** The frontend service uses the official Nginx image as a base.
-   **Custom Configuration:** A custom Nginx configuration is used to serve the static content.
-   **Non-root User:** The container runs as a non-root user.

*File:* `services/frontend/Dockerfile`

## 3. Kubernetes Deployment on GKE

The containerized application is deployed on the GKE cluster using Kubernetes manifests.

### 3.1. Microservices Deployment

-   **Backend Deployment:** The backend service is deployed as a Kubernetes Deployment with multiple replicas for high availability.
-   **Frontend Deployment:** The frontend service is deployed using a canary release strategy. There are two deployments: `frontend-primary` and `frontend-canary`.

*Files:* `k8s/backend-deploy.yaml`, `k8s/frontend-deploy-primary.yaml`, `k8s/frontend-deploy-canary.yaml`

### 3.2. Horizontal Pod Autoscaler (HPA)

-   **Backend HPA:** A Horizontal Pod Autoscaler is configured for the backend service to automatically scale the number of pods based on CPU utilization.

*File:* `k8s/hpa-backend.yaml`

### 3.3. Ingress and TLS

-   **Ingress Controller:** An Nginx Ingress Controller is used to manage external access to the services.
-   **TLS Certificate:** A TLS certificate is automatically provisioned using cert-manager and Let's Encrypt to secure the application.

*Files:* `k8s/ingress-nginx.yaml`, `k8s/cluster-issuer.yaml`

### 3.4. Canary Release

-   **Canary Deployment:** The frontend service is deployed using a canary release strategy. The `frontend-canary` deployment receives a small percentage of the traffic, allowing for testing in production before a full rollout.

*Files:* `k8s/frontend-deploy-primary.yaml`, `k8s/frontend-deploy-canary.yaml`


## Architecture

The infrastructure consists of the following components:

*   **VPC Network**: A custom Virtual Private Cloud (VPC) to provide a secure and isolated network for the application.
*   **GKE Cluster**: A regional Google Kubernetes Engine cluster serves as the container orchestration platform.
*   **Compute Engine VMs**:
    *   A **Bastion Host** for secure administrative access.
    *   A **Utility VM** for running miscellaneous tasks.
*   **Artifact Registry**: A private Docker image repository to store and manage container images.
*   **IAM**: Identity and Access Management roles are configured to ensure the principle of least privilege.

The application is composed of two microservices:

*   **Frontend**: A simple Nginx web server serving a static "Hello World" page.
*   **Backend**: A Python Flask application providing a simple API endpoint.

Traffic is routed to the application via a Google Cloud Load Balancer, which is managed by an NGINX Ingress Controller running in the GKE cluster. TLS is handled by `cert-manager`, which automatically provisions certificates from Let's Encrypt.

### Architecture Diagram

```
[ User ] -> [ Internet ] -> [ Google Cloud Load Balancer (Ingress) ]
                                |
                                v
[ GKE Cluster ] <-----------------
    |
    +--> [ Ingress Controller ] -> [ Frontend Service ] -> [ Frontend Pods (Nginx) ]
    |
    +--> [ Ingress Controller ] -> [ Backend Service ]  -> [ Backend Pods (Flask) ]

[ Artifact Registry ] <--- (Docker Images) --- [ Cloud Build / Local Docker ]
```

## Setup and Deployment

### Prerequisites

*   Google Cloud SDK (`gcloud`)
*   Terraform
*   Docker
*   `kubectl`

### 1. Provision Infrastructure

1.  **Configure Terraform:**
    *   Navigate to the `terraform/` directory.
    *   Create a `terraform.tfvars` file based on the `tfvars.example`.
    *   Fill in your GCP `project_id` and `deployer_user_email`.

2.  **Apply Terraform:**
    ```bash
    cd terraform
    terraform init
    terraform validate
    terraform plan -var-file="envs/dev/terraform.tfvars"
    terraform apply -var-file="envs/dev/terraform.tfvars"
    ```

### 2. Build and Push Docker Images

1.  **Authenticate Docker:**
    ```bash
    gcloud auth configure-docker asia-south1-docker.pkg.dev
    ```

2.  **Run the Build Script:**
    *   Open a PowerShell terminal.
    *   Navigate to the project root.
    *   Run the script:
        ```powershell
        .\build-and-push.ps1
        ```

### 3. Deploy to GKE

1.  **Get Cluster Credentials:**
    ```bash
    gcloud container clusters get-credentials wobot-gke --region asia-south1
    ```

2.  **Apply Kubernetes Manifests:**
    ```bash
    # Apply the namespace first
    kubectl apply -f k8s/namespace.yaml

    # Apply all other resources
    kubectl apply -f k8s/
    ```

3.  **Install Ingress Controller and Cert-Manager:**
    ```bash
    # Ingress Controller
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

    # Cert-Manager
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
    ```

4.  **Configure TLS:**
    *   Update `k8s/cluster-issuer.yaml` with your email address.
    *   Apply the issuer:
        ```bash
        kubectl apply -f k8s/cluster-issuer.yaml
        ```
    *   Update `k8s/ingress-nginx.yaml` with your domain name.
    *   Apply the ingress changes:
        ```bash
        kubectl apply -f k8s/ingress-nginx.yaml
        ```

### 4. Accessing the Application

Find the external IP of your Ingress controller:
```bash
kubectl get services -n ingress-nginx
```

You can then access your application at `https://wobot.example.com`.

---

### **Summary of Our Journey**

1.  We started by defining all our cloud resources in **Terraform** code.
2.  We hit several **quota limits** with the GCP free tier, which we solved by adjusting our resource sizes and configurations.
3.  We ran into a **Terraform state issue** (`deletion_protection`) which we solved by manually deleting the broken GKE cluster with `gcloud` commands, allowing Terraform to start fresh.
4.  We then created simple **Flask** and **Nginx** applications and wrote **Dockerfiles** to containerize them, optimizing them with multi-stage builds and non-root users.
5.  We pushed these container images to our private **Artifact Registry**.
6.  We wrote **Kubernetes manifest files** to define how our application should run, be exposed, and scale on GKE.
7.  We deployed the application with **`kubectl`** and ran into an `ImagePullBackOff` error, which we fixed by granting the correct **IAM permissions** to the GKE nodes.
8.  Finally, we installed **cert-manager** and configured our **Ingress** to automatically handle **TLS (HTTPS)**, completing all the core technical requirements of the assignment.

