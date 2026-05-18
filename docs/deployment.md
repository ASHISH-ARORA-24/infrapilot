# Deployment Documentation

## Point 1 — Settings Architecture

`settings.py` is the base settings file and covers local development as-is (`DEBUG = True`, SQLite, no `ALLOWED_HOSTS` restrictions).

Each deployment type has its own settings file that only contains overrides specific to that environment:

```
infrapilot/
  settings.py              ← base settings (local dev default)
  settings_local.py        ← local overrides (if needed)
  settings_deploy_aas.py   ← Azure App Service overrides
  settings_deploy_aca.py   ← Azure Container Apps overrides
  settings_deploy_aks.py   ← Azure Kubernetes Service overrides
  settings_deploy_avm.py   ← Azure Virtual Machine overrides
```

At the bottom of `settings.py`, the correct settings file is loaded based on the `DEPLOYMENT_TYPE` environment variable:

```python
DEPLOYMENT_TYPE = os.getenv("DEPLOYMENT_TYPE", "local")

if DEPLOYMENT_TYPE == "local":
    from infrapilot.settings_local import *
elif DEPLOYMENT_TYPE == "aas":
    from infrapilot.settings_deploy_aas import *
elif DEPLOYMENT_TYPE == "aca":
    from infrapilot.settings_deploy_aca import *
elif DEPLOYMENT_TYPE == "aks":
    from infrapilot.settings_deploy_aks import *
elif DEPLOYMENT_TYPE == "avm":
    from infrapilot.settings_deploy_avm import *
```

### Rules

- `settings.py` is never modified for deployment-specific config
- Each `settings_deploy_*.py` only contains overrides — nothing more
- If `DEPLOYMENT_TYPE` is not set, it defaults to `local`
- `settings_local.py` can be empty or hold developer-specific overrides

---

## Point 2 — Environment Strategy

The project supports four environments:

| Environment | How it is deployed                        |
|-------------|-------------------------------------------|
| sandbox     | Manually from local laptop                |
| dev         | Pipeline only                             |
| qa          | Pipeline only                             |
| prod        | Pipeline only                             |

### Sandbox

- Triggered manually from a local laptop
- Deploys into Azure cloud (not a local simulation)
- Used for personal experimentation and testing
- Completely isolated from the dev/qa/prod pipeline flow
- Terraform commands are run locally for sandbox deployments

### Dev / QA / Prod

- All deployments go through the pipeline only
- No manual deployments allowed outside of sandbox
- Each environment is independent and can be deployed or rolled back without affecting the others

---

## Point 3 — Cloud and Authentication

- Cloud provider: **Microsoft Azure**
- All deployments — pipeline and manual sandbox — are performed using a **service account (Azure Service Principal) only**
- No personal credentials are ever used for deployments
- The service principal credentials are stored as secrets in GitHub Actions for pipeline deployments
- For sandbox (local), the service principal credentials are set as environment variables on the local machine
