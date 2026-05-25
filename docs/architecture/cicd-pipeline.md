# CI/CD Pipeline Architecture

## Overview

Every code change merged to `main` automatically flows through a two-pipeline system that versions, builds, and deploys the app across all environments with zero downtime.

---

## Pipeline 1: App Release (`app_release.yml`)

**Trigger:** Push to `main` (excluding `deployment/`, `.github/`, `docs/`, and `*.md` files)

**Steps in order:**

| Step | Tool | What it does |
|---|---|---|
| Lint | black, isort, flake8 | Enforces code formatting standards |
| Test | pytest | Runs the test suite |
| Release | python-semantic-release | Bumps version, updates CHANGELOG.md, commits back to main with `[skip ci]` |
| Bootstrap ACR | Azure CLI | Ensures Azure Container Registry exists |
| Bootstrap Secrets | bash script | Ensures Django secret keys exist as GitHub secrets |
| Docker | docker/build-push-action | Builds Docker image and pushes to ACR with the new version tag |

### Versioning Rules

Version bumps are driven entirely by commit message prefixes:

| Commit prefix | Version bump |
|---|---|
| `feat:` | minor (0.1.0 → 0.2.0) |
| `fix:` | patch (0.1.0 → 0.1.1) |
| `refactor:` | patch (0.1.0 → 0.1.1) |
| `chore:`, `ci:`, `docs:`, `style:`, `test:` | no bump |

### Why `[skip ci]` on the release commit

`semantic-release` commits the version bump (`pyproject.toml` + `CHANGELOG.md`) back to `main`. Without `[skip ci]` in that commit message, GitHub Actions would re-trigger the pipeline, causing duplicate runs. The `[skip ci]` tag tells GitHub to ignore that commit.

---

## Pipeline 2: App Deploy (`aas_deploy.yml`)

**Trigger:** Automatically after `App Release` completes successfully, or manually via `workflow_dispatch`

**Deployment order:** dev → qa → prod (each environment requires manual approval before swap)

### How Slot Swapping Works

Each environment has two slots: **production** and **staging**.

```
New Docker image
      ↓
Push to staging slot
      ↓
Azure warms up the app + health check
      ↓
Swap staging ↔ production   (zero downtime)
      ↓
Old version now sits in staging (easy rollback)
```

This means users on the production URL never see downtime — traffic is only switched after the new version is confirmed healthy on staging.

---

## Infrastructure (`Terraform`)

Provisioned manually per environment via the `aas_tf_apply` pipeline. Each environment (dev, qa, prod) creates identical resources:

| Resource | Azure Type | Purpose |
|---|---|---|
| Resource Group | `azurerm_resource_group` | Container for all environment resources |
| App Service Plan | `azurerm_service_plan` | The compute layer that runs the app |
| PostgreSQL Flexible Server | `azurerm_postgresql_flexible_server` | Application database |
| Key Vault | `azurerm_key_vault` | Secure storage for secrets |
| App Service | `azurerm_linux_web_app` | The web app with production + staging slots |
| Key Vault Access Policies | `azurerm_key_vault_access_policy` | Grants both slots permission to read secrets |

### How Secrets Are Managed

Secrets are never stored as plain text in app settings. Instead, Key Vault references are used:

```
SECRET_KEY = @Microsoft.KeyVault(VaultName=kv-infrap-aas-dev;SecretName=django-secret-key)
DB_PASSWORD = @Microsoft.KeyVault(VaultName=kv-infrap-aas-dev;SecretName=db-admin-password)
```

Azure resolves these references at runtime by fetching the value directly from Key Vault using the app's managed identity.

---

## End-to-End Flow

```
Developer merges PR to main
          ↓
app_release.yml
  ├── lint + test
  ├── semantic-release → version bump committed with [skip ci]
  └── Docker image built and pushed to ACR
          ↓
aas_deploy.yml
  ├── dev:  push image to staging → swap → production
  ├── qa:   push image to staging → swap → production
  └── prod: push image to staging → swap → production
          ↓
App is live across all environments
```

---

## Infra Pipelines

There are 6 infrastructure pipelines, each serving a distinct purpose.

---

### `aas_tf_plan_apply.yml` — Auto Plan and Apply

**Trigger:** Automatically on PR or merge to `main`, but **only when files under `deployment/aas/env/`** change.

**Smart change detection:** Uses `dorny/paths-filter` to detect which environment folder changed. If only `dev/` was touched, only the dev job runs. If all three changed, all three run in parallel. No unnecessary applies.

**On PR:** Runs `terraform plan` and posts the full output as a comment on the PR — so you can review exactly what will change in Azure before merging.

**On merge to main:** Runs `terraform plan` + `terraform apply` automatically.

This pipeline delegates the actual work to `_aas_tf_env.yml`.

---

### `_aas_tf_env.yml` — Reusable Terraform Worker

Not triggered directly — called by `aas_tf_plan_apply.yml`. Acts as a shared function to avoid duplicating plan/apply logic. Takes `environment`, `working_dir`, and `apply` as inputs.

---

### `aas_tf_apply.yml` — Manual On-Demand Apply

**Trigger:** Manual only — you pick the environment (dev/qa/prod) from a dropdown in GitHub Actions.

**Difference from `aas_tf_plan_apply.yml`:** Skips the plan step and goes straight to `terraform apply`. No change detection — runs whatever environment you select.

**Primary use case:** Re-provisioning an environment from scratch after it has been destroyed. Since no Terraform files changed, `aas_tf_plan_apply.yml` would not trigger — this pipeline is the only way to provision in that scenario.

---

### `aas_tf_destroy.yml` — Scheduled Environment Destroyer

**Trigger:** Every hour (`0 * * * *`) or manually via `workflow_dispatch`.

**What it does:** Destroys dev, qa, and prod simultaneously using a matrix strategy. Each environment runs in parallel with `fail-fast: false` so one failure doesn't stop the others.

**Why scheduled?** Cost saving — resources are torn down automatically every hour so you are not paying for idle Azure infrastructure.

**Manual trigger bonus:** Accepts a `log_level` input (DEBUG, TRACE, INFO, etc.) for troubleshooting failed destroys.

---

### `aas_tf_sandbox_destroy.yml` — Sandbox Destroyer

Same as `aas_tf_destroy.yml` but scoped to the sandbox environment only, also on the hourly schedule.

**Key difference from other environments:** Sandbox generates a fresh random Django secret key on every run (`openssl rand -base64 32`) instead of reading from GitHub secrets, because sandbox is ephemeral and not tied to persistent secrets.

---

### `aas_tf_unlock.yml` — State Lock Breaker

**Trigger:** Manual only.

**Problem it solves:** Terraform stores a lock in Azure Blob Storage to prevent two applies running simultaneously. If a pipeline crashes mid-apply, the lock is never released — all future applies fail with a "state locked" error.

**What it does:** Breaks the blob lease on the `tfstate` file for the selected environment, freeing the lock so Terraform can run again.

---

### Infra Pipeline Flow

```
Terraform file changed in a PR
          ↓
aas_tf_plan_apply.yml → plan output posted as PR comment
          ↓
PR merged to main
          ↓
aas_tf_plan_apply.yml → auto applies the change

─────────────────────────────────────────

Environment destroyed, need to re-provision?
          ↓
aas_tf_apply.yml (manual, pick environment)

─────────────────────────────────────────

Every hour (cost saving)
          ↓
aas_tf_destroy.yml        → destroys dev + qa + prod
aas_tf_sandbox_destroy.yml → destroys sandbox

─────────────────────────────────────────

Apply stuck / state lock error?
          ↓
aas_tf_unlock.yml (manual, pick environment)
```

---

## Azure Components

---

### 1. Resource Group (`rg-infrap-aas-dev`)

**What it is:** A logical container in Azure. Every Azure resource must live inside a resource group.

**Purpose:** Groups all resources for a single environment together. Deleting one resource group removes everything inside it — the cleanest way to tear down an entire environment.

**Naming:** `rg-{project}-{deployment_type}-{environment}`

---

### 2. App Service Plan (`asp-infrap-aas-dev`)

**What it is:** The underlying compute (server) that your web app runs on. Defines how much CPU and RAM you get and how much you pay.

**Purpose:** Your App Service sits on top of this plan. Each environment has its own dedicated plan so resources are isolated.

---

### 3. App Service (`app-infrap-aas-dev`)

**What it is:** The actual web app that serves your Django application — what users hit when they open your URL.

**Purpose:**
- Runs your Docker image pulled from ACR
- Has two slots — **production** (live) and **staging** (warm-up) — enabling zero downtime deployments
- Uses a **System Assigned Managed Identity** to authenticate with ACR and Key Vault without storing any passwords

**Slots:**

| Slot | Purpose |
|---|---|
| Production | Live URL, what users see |
| Staging | New version warms up here, then swapped into production |

---

### 4. Azure Container Registry (`crinfrap`)

**What it is:** A private Docker image registry hosted in Azure. Like Docker Hub but private and inside your Azure account.

**Purpose:** Stores every versioned Docker image of your app. The release pipeline pushes new images here; the deployment pipeline tells App Service to pull from here.

**Lives in:** `rg-infrap-bootstrap` — shared across all environments, you only need one registry.

**Images stored as:**
```
crinfrap.azurecr.io/infrapilot:1.6.1   ← versioned
crinfrap.azurecr.io/infrapilot:latest  ← always points to newest
```

---

### 5. PostgreSQL Flexible Server (`psql-infrap-aas-dev`)

**What it is:** A fully managed PostgreSQL database hosted by Azure. Azure handles the server, OS, and patches.

**Purpose:** Stores all application data. Your app connects using `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` environment variables.

**Firewall rule:** `AllowAzureServices` (IP `0.0.0.0` to `0.0.0.0`) — Azure's special rule that allows other Azure services (App Service) to connect without exposing the database to the public internet.

---

### 6. Key Vault (`kv-aas-dev-xxxx`)

**What it is:** Azure's secret manager. Stores sensitive values securely with access control and audit logging.

**Purpose:** Stores two secrets per environment:
- `django-secret-key` — Django's cryptographic key for signing cookies and sessions
- `db-admin-password` — The PostgreSQL admin password (randomly generated by Terraform)

**How the app reads secrets:** Instead of storing the actual value in app settings, a Key Vault reference is used:
```
SECRET_KEY  = @Microsoft.KeyVault(VaultName=kv-aas-dev-xxxx;SecretName=django-secret-key)
DB_PASSWORD = @Microsoft.KeyVault(VaultName=kv-aas-dev-xxxx;SecretName=db-admin-password)
```
Azure resolves these at runtime — the secret value never appears in plain text anywhere.

**Why the random suffix in the name:** Key Vault names must be globally unique across all of Azure. The random suffix prevents name collisions.

**Soft delete (7 days):** If a Key Vault is accidentally deleted it stays recoverable for 7 days before being permanently removed.

---

### 7. Key Vault Access Policies

**What they are:** Permission rules controlling who can read or write secrets in Key Vault.

**Three policies per environment:**

| Policy | Who | Permissions | Why |
|---|---|---|---|
| `terraform_sp` | Service principal running Terraform | Get, List, Set, Delete, Purge | So Terraform can create and manage secrets |
| `app_service` | Production slot managed identity | Get, List | So the live app can read secrets at runtime |
| `app_service_staging` | Staging slot managed identity | Get, List | So the staging app can read secrets before swap |

---

### 8. Storage Account (`stinfrapilottf`) — Bootstrap

**What it is:** Azure blob storage. Lives in `rg-infrap-bootstrap`, shared across all environments.

**Purpose:** Stores Terraform state files (`aas_dev.tfstate`, `aas_qa.tfstate`, etc.). Terraform uses these to track what resources it has created so it knows what to add, change, or delete on the next run.

**Why in Azure and not locally:** Storing state in Azure means the pipeline and any team member can run Terraform safely. The state file is locked during a run to prevent two applies conflicting at the same time.

---

### How All Components Connect

```
GitHub Actions (CI/CD)
        │
        ├── builds Docker image
        │         ↓
        │   Azure Container Registry (crinfrap)
        │         ↓
        └── tells App Service to pull new image
                  ↓
        App Service Plan (compute)
          └── App Service (web app)
                ├── production slot  ←── users hit this
                └── staging slot     ←── new version warms up here
                        │
                        ├── reads secrets from Key Vault
                        │     ├── django-secret-key
                        │     └── db-admin-password
                        │
                        └── connects to PostgreSQL
                              └── infrapilot database

Terraform state → stored in Storage Account
All resources grouped per environment → Resource Group
```

---

## Common Issues and Fixes

| Issue | Root Cause | Fix |
|---|---|---|
| Duplicate pipeline runs | `semantic-release` commits back to `main`, re-triggering the pipeline | Add `commit_message = "chore(release): {version} [skip ci]"` to `[tool.semantic_release]` in `pyproject.toml` |
| Slot swap failing | App crashes on startup in staging slot — no database configured | Ensure `postgresql` and `keyvault` modules are present in the environment's `main.tf` |
| Resource group stuck in `Deleting` | Azure backend issue | Re-run `az group delete` to unstick, or raise an Azure support ticket |
