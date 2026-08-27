# [1/3] Cloud-Native Platform — GCP Infrastructure, Cloud SQL & Private GKE

[![GCP](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![Security](https://img.shields.io/badge/Security-Zero_Trust-00C853?style=for-the-badge)](#security--zero-trust-posture)

> **Enterprise Cloud-Native Infrastructure:** A production-grade, fully automated Terraform deployment of a secure Google Kubernetes Engine (GKE) cluster, deeply integrated with a private Cloud SQL PostgreSQL database via Private Service Connect (PSC), and equipped with Workload Identity Federation (WIF) for keyless CI/CD authentication.

---

## Executive Summary

This repository provisions the foundational infrastructure (Project 1 of 3) for a modern Cloud-Native ecosystem on Google Cloud Platform. It focuses on modular Infrastructure as Code (IaC) to establish a highly secure, private-by-default environment ready to host microservices and automate container image publishing without static credentials.

---

## Security & Zero-Trust Posture

* **Keyless CI/CD Authentication (Workload Identity Federation):** OIDC-based federation with GitHub Actions eliminates long-lived Service Account JSON keys. Access is cryptographically scoped to the specific repository owner (`assertion.repository_owner`).
* **100% Private Network:** The GKE cluster nodes and the Cloud SQL database have no public IP addresses.
* **Private Service Connect (PSC):** Database connectivity is handled internally via a local PSC Endpoint, eliminating the need for VPC Peering or public exposure.
* **Least Privilege IAM:** Dedicated Service Accounts are assigned to GKE nodes (`roles/logging.logWriter`, `roles/monitoring.metricWriter`) and CI/CD (`roles/artifactregistry.writer`), avoiding default Compute Engine permissions.
* **Enforced Encryption:** Cloud SQL is strictly configured with `ssl_mode = "ENCRYPTED_ONLY"` to enforce TLS on all database connections.
* **IAP-Ready:** Network firewalls are configured to allow Identity-Aware Proxy (IAP) tunneling for secure, bastionless administration.

---

## Architecture Diagram

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#ffffff',
      'primaryBorderColor': '#475569',
      'lineColor': '#475569',
      'textColor': '#0f172a'
    }
  }
}%%
graph TD
    style GCP_PROJECT fill:#f1f5f9,stroke:#334155,stroke-width:2px
    style VPC fill:#eff6ff,stroke:#3b82f6,stroke-width:2px
    style GKE_SUBNET fill:#f0fdf4,stroke:#22c55e,stroke-width:2px
    style GCP_MANAGED fill:#fefce8,stroke:#eab308,stroke-width:2px
    style GITHUB_ACTIONS fill:#f8fafc,stroke:#64748b,stroke-width:2px

    classDef gcpBlue fill:#ffffff,stroke:#2563eb,stroke-width:2px,color:#1e3a8a;
    classDef gcpGreen fill:#ffffff,stroke:#16a34a,stroke-width:2px,color:#14532d;
    classDef gcpYellow fill:#ffffff,stroke:#ca8a04,stroke-width:2px,color:#713f12;
    classDef github fill:#ffffff,stroke:#0f172a,stroke-width:2px,color:#0f172a;

    subgraph GITHUB_ACTIONS["<b>External CI/CD Platform</b>"]
        GHA["GitHub Actions Workflow<br/>(Repo 03)"]:::github
    end

    subgraph GCP_PROJECT["<font color='#0f172a'><b>GCP Project: gke-devsecops-stack</b></font>"]
        
        WIF["Workload Identity Pool & Provider<br/>(OIDC Trust with GitHub)"]:::gcpBlue
        GHA_SA["CI/CD Service Account<br/>(roles/artifactregistry.writer)"]:::gcpBlue
        AR["Artifact Registry<br/>(Docker Images)"]:::gcpBlue

        subgraph VPC["<font color='#1e40af'><b>Custom VPC Network (100% Private)</b></font>"]
            
            subgraph GKE_SUBNET["<font color='#166534'><b>Private Subnet & Secondary Ranges</b></font>"]
                GKE_Nodes["GKE Worker Nodes<br/>(Private IP Only)"]:::gcpGreen
                GKE_Pods["GKE Pods (Secondary IP Range)"]:::gcpGreen
                PSC_Endpoint["PSC Endpoint<br/>(Local Cloud SQL Interface)"]:::gcpGreen
            end
            
            NAT["Cloud Router + Cloud NAT<br/>(Outbound Egress)"]:::gcpBlue
            IAP["Identity-Aware Proxy (IAP)<br/>(Firewall Allowed)"]:::gcpBlue
        end

        subgraph GCP_MANAGED["<font color='#854d0e'><b>Google Managed Services</b></font>"]
            GKE_ControlPlane["GKE Control Plane<br/>(Google Managed VPC)"]:::gcpYellow
            CloudSQL[("Cloud SQL PostgreSQL<br/>- Encrypted Only<br/>- Private via PSC")]:::gcpYellow
        end
    end

    GHA -->|1. Exchange OIDC Token| WIF
    WIF -->|2. Impersonate| GHA_SA
    GHA_SA -->|3. Push Container Images| AR
    GKE_Nodes -->|4. Pull Images| AR
    GKE_Nodes -.->|Egress| NAT
    GKE_ControlPlane <==>|Peering / Management| GKE_Nodes
    GKE_Pods -->|SQL :5432| PSC_Endpoint
    PSC_Endpoint ==>|Private PSC Tunnel| CloudSQL
```

---

## Repository Structure

```text
.
├── .gitignore               # Strict exclusion patterns for secrets and state
├── main.tf                  # Root module invocations & platform assembly
├── outputs.tf               # Infrastructure deployment outputs
├── providers.tf             # Terraform provider configuration
├── terraform.tfvars.example # Example variable input values
├── variables.tf             # Core variable definitions
└── modules/
    ├── database/            # Cloud SQL PostgreSQL and PSC forwarding rule
    ├── gke/                 # Private GKE Cluster and dedicated Node Pool
    ├── iam/                 # Workload Identity Federation (WIF) & GitHub SA
    ├── network/             # Custom VPC, private subnets, Cloud Router & NAT
    ├── registry/            # Artifact Registry Docker repository
    └── security/            # GKE Node Service Account & IAP firewall rules
```

---

## Module Inventory & Inputs

| Module | Resource Provided | Key Security / Design Features |
| :--- | :--- | :--- |
| `network` | VPC, Subnet, Router, NAT | 100% private topology, NAT egress for updates. |
| `security` | Node SA, Firewall | Enforces least privilege, IAP access rule (35.235.240.0/20). |
| `database` | Cloud SQL, PSC Endpoint | Private Service Connect tunneling, encrypted-only TLS connections. |
| `gke` | Private GKE Cluster, Node Pool | Private nodes/endpoint, custom SA binding. |
| `registry` | Artifact Registry Repository | Private Docker format registry. |
| `iam` | WIF Pool, Provider & CI/CD SA | Keyless OIDC federation for GitHub Actions. |

---

## Deployment Quickstart

### Prerequisites

* **Google Cloud SDK (`gcloud`)** installed and authenticated.
* **Terraform** `>= 1.5.0`

### 1. Configure Authentication & Variables

```bash
# Authenticate with GCP
gcloud auth login
gcloud auth application-default login

# Initialize variable file
cp terraform.tfvars.example terraform.tfvars
```

Fill `terraform.tfvars` with your target environment details:

```hcl
project_id      = "gke-devsecops-stack-26"
region          = "europe-west9"
github_username = "your-github-username"
```

### 2. Provision Infrastructure

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### 3. Retrieve Cluster Credentials & CI/CD Variables

Upon successful completion, Terraform exposes the required platform endpoints and IAM credentials:

```bash
# Connect to the private GKE cluster
gcloud container clusters get-credentials $(terraform output -raw cluster_name) \
    --region europe-west9 \
    --project $(terraform output -raw project_id)

# Fetch Workload Identity outputs for CI/CD setup
terraform output gcp_workload_identity_provider
terraform output gcp_service_account_email
```

---

## CI/CD Pipeline Integration (Repo 03)

To allow repository **`03-sample-app-microservice`** to authenticate and push container images automatically via GitHub Actions:

1. Navigate to **`03-sample-app-microservice` > Settings > Secrets and variables > Actions > Variables**.
2. Add the following repository variables using the outputs from this deployment:

| GitHub Variable Name | Value Source (Terraform Output) |
| :--- | :--- |
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | `gcp_workload_identity_provider` |
| `GCP_SERVICE_ACCOUNT` | `gcp_service_account_email` |

---

## Platform Ecosystem

This repository is **Part 1 of 3** in the Cloud-Native End-to-End Platform series:

1. **`01-platform-infra-terraform`** *(This repository)* — Provisioning base cloud infrastructure (VPC, GKE Private, Cloud SQL, Artifact Registry, Workload Identity Federation).
2. [**`02-platform-gitops-config`**](https://github.com/vladimir-evdokimov-pro/02-platform-gitops-config) — GitOps engine, Kubernetes controllers & cluster configuration (ArgoCD, Ingress, Cert-Manager).
3. [**`03-sample-app-microservice`**](https://github.com/vladimir-evdokimov-pro/03-sample-app-microservice) — Microservice application workloads and deployment manifests.