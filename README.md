# 01-platform-infra-terraform
## [1/3] Cloud-Native Platform — Infrastructure GCP, Cloud SQL & Cluster GKE Privé (Terraform)

Ce dépôt contient le code **Terraform** permettant de provisionner une infrastructure sécurisée et hautement disponible sur **Google Cloud Platform (GCP)**.

L'architecture est entièrement modulaire et respecte les principes du moindre privilège, de l'isolation réseau et du chiffrement strict.

---

## Architecture déployée

* **Réseau (`modules/vpc`) :** VPC dédié, sous-réseau, Cloud Router et Cloud NAT pour l'accès internet sortant des ressources privées.
* **Registre (`modules/registry`) :** Dépôt Artifact Registry au format Docker.
* **Sécurité (`modules/security`) :** Service Account dédié aux nœuds GKE, rôles IAM minimaux et règle de pare-feu IAP pour l'accès SSH.
* **Kubernetes (`modules/gke`) :** Cluster GKE privé avec sous-réseau et plages d'IP secondaires (Pods et Services).
* **Base de données (`modules/database`) :** Instance Cloud SQL PostgreSQL (v18) sans IP publique, connectée via **Private Service Connect (PSC)** et avec chiffrement SSL/TLS forcé (`ENCRYPTED_ONLY`).

---

## Prérequis

1. **Terraform** (`>= 1.5.0`) installé localement.
2. **Google Cloud SDK (`gcloud`)** installé et configuré.
3. Un projet GCP actif avec les droits d'administration (`roles/owner` ou `roles/resourcemanager.organizationAdmin`).

---

## Structure du projet

```text
.
├── main.tf                  # Assemblage des modules et activation des API
├── variables.tf             # Variables globales à la racine
├── outputs.tf               # Sorties globales de la stack
├── providers.tf             # Configuration du provider Google
├── terraform.tfvars.example  # Modèle de variables
└── modules/
    ├── vpc/                 # Réseau, Subnet, Router, NAT
    ├── registry/            # Artifact Registry
    ├── security/            # IAM, Service Accounts, Firewall IAP
    ├── gke/                 # Cluster GKE
    └── database/            # Cloud SQL PostgreSQL + PSC
```

---

## Modèle de configuration (`terraform.tfvars.example`)

Contenu à placer dans le fichier `terraform.tfvars.example` à la racine :

```hcl
# --- Configuration GCP obligatoire ---
project_id = "votre-project-id-gcp"

# --- Localisation des ressources ---
region = "europe-west1"
zone   = "europe-west1-b"

# --- Optionnel : Personnalisation des API à activer ---
# gcp_apis = [
#   "compute.googleapis.com",
#   "container.googleapis.com",
#   "artifactregistry.googleapis.com",
#   "iam.googleapis.com",
#   "sqladmin.googleapis.com",
#   "servicenetworking.googleapis.com"
# ]
```

---

## Procédure de déploiement

### 1. Authentification GCP

Connecte ton terminal à ton compte GCP et génère les accès d'application :

```bash
gcloud auth login
gcloud auth application-default login
```

### 2. Configuration des variables

Duplique le fichier d'exemple et renseigne ton `project_id` GCP :

```bash
cp terraform.tfvars.example terraform.tfvars
```

Édite `terraform.tfvars` :

```hcl
project_id = "votre-project-id-réel"
region     = "europe-west1"
zone       = "europe-west1-b"
```

### 3. Initialisation et validation

Initialise les modules et vérifie la conformité du code :

```bash
terraform init
terraform validate
```

### 4. Planification et déploiement

Simule la création des ressources puis applique le déploiement :

```bash
terraform plan
terraform apply
```

---

## Sorties principales (`outputs`)

Une fois l'infrastructure déployée, Terraform fournit les informations clés :

* `cluster_name` / `cluster_endpoint` : informations d'accès au cluster GKE.
* `db_private_ip` : adresse IP interne du point de terminaison PSC pour Cloud SQL.
* `db_name` / `db_user` / `db_password` : identifiants de la base de données (le mot de passe est masqué car marqué comme `sensitive`).

Pour afficher le mot de passe généré :

```bash
terraform output -raw db_password
```