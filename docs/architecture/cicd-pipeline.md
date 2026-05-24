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

## Common Issues and Fixes

| Issue | Root Cause | Fix |
|---|---|---|
| Duplicate pipeline runs | `semantic-release` commits back to `main`, re-triggering the pipeline | Add `commit_message = "chore(release): {version} [skip ci]"` to `[tool.semantic_release]` in `pyproject.toml` |
| Slot swap failing | App crashes on startup in staging slot — no database configured | Ensure `postgresql` and `keyvault` modules are present in the environment's `main.tf` |
| Resource group stuck in `Deleting` | Azure backend issue | Re-run `az group delete` to unstick, or raise an Azure support ticket |
