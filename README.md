# [1/3] Cloud-Native Platform — GCP Infrastructure, Cloud SQL & Private GKE

[![GCP](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Security](https://img.shields.io/badge/Security-Zero_Trust-00C853?style=for-the-badge)](#security--zero-trust-posture)

> **Enterprise Cloud-Native Infrastructure:** A production-grade, fully automated Terraform deployment of a secure Google Kubernetes Engine (GKE) cluster, deeply integrated with a private Cloud SQL PostgreSQL database via Private Service Connect (PSC).

---

## Executive Summary

This repository provisions the foundational infrastructure (Project 1 of 3) for a modern Cloud-Native ecosystem on Google Cloud Platform. It focuses on modular Infrastructure as Code (IaC) to establish a highly secure, private-by-default environment ready to host microservices.

---

## Security & Zero-Trust Posture

* **100% Private Network:** The GKE cluster nodes and the Cloud SQL database have no public IP addresses.
* **Private Service Connect (PSC):** Database connectivity is handled internally via a local PSC Endpoint, eliminating the need for VPC Peering or public exposure.
* **Least Privilege IAM:** A dedicated Service Account is bound to the GKE nodes, preventing the use of the default Compute Engine service account.
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

    classDef gcpBlue fill:#ffffff,stroke:#2563eb,stroke-width:2px,color:#1e3a8a;
    classDef gcpGreen fill:#ffffff,stroke:#16a34a,stroke-width:2px,color:#14532d;
    classDef gcpYellow fill:#ffffff,stroke:#ca8a04,stroke-width:2px,color:#713f12;

    subgraph GCP_PROJECT["<font color='#0f172a'><b>GCP Project: gke-devsecops-stack</b></font>"]
        
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
            CloudSQL[("Cloud SQL PostgreSQL 18<br/>- Encrypted Only<br/>- Private via PSC")]:::gcpYellow
        end
    end

    GKE_Nodes -->|Pull Images| AR
    GKE_Nodes -.->|Egress| NAT
    GKE_ControlPlane <==>|Peering / Management| GKE_Nodes
    GKE_Pods -->|SQL :5432| PSC_Endpoint
    PSC_Endpoint ==>|Private PSC Tunnel| CloudSQL

```

---

## Repository Structure

```text
.
├── main.tf                  # Infrastructure module invocations
├── outputs.tf               # Infrastructure deployment outputs
├── providers.tf             # Terraform provider definitions
├── terraform.tfvars.example # Input variables example template
├── variables.tf             # Core variable definitions
└── modules/
    ├── database/            # Cloud SQL PostgreSQL and PSC provisioning
    ├── gke/                 # Private Kubernetes Cluster
    ├── registry/            # Artifact Registry Docker repository
    ├── network/             # VPC, subnets, NAT, and secondary ranges
    └── security/            # IAM, Service Accounts & IAP Firewall
```

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

# Setup variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your GCP project details
```

### 2. Provision Infrastructure

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### 3. Retrieve Credentials

Once deployed, retrieve your database credentials and cluster connection info:

```bash
# Get the auto-generated database password
terraform output -raw db_password

# Connect to the GKE cluster
gcloud container clusters get-credentials $(terraform output -raw cluster_name) \
    --region $(terraform output -raw region) \
    --project $(terraform output -raw project_id)
```

---

## Platform Ecosystem

This repository is **Part 1 of 3** in the Cloud-Native End-to-End Platform series:

1. **`01-platform-infra-terraform`** *(This repository)* — Provisioning base cloud infrastructure (VPC, GKE Private, Cloud SQL, Artifact Registry).
2. [**`02-platform-gitops-config`**](https://github.com/vladimir-evdokimov-pro/02-platform-gitops-config) — GitOps engine, Kubernetes controllers & cluster configuration (ArgoCD, Ingress, Cert-Manager).
3. [**`03-sample-app-microservice`**](https://github.com/vladimir-evdokimov-pro/03-sample-app-microservice) — Microservice application workloads and deployment manifests.