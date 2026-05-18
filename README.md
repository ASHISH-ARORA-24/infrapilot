# Enterprise Multi-Deployment Learning Platform

## Project Vision

This project is a complete enterprise-style learning platform designed to teach:

* Django application development
* Azure deployment models
* Infrastructure-as-Code (IaC)
* Terraform architecture
* GitHub Actions CI/CD
* Deployment governance
* Rollback mechanisms
* Environment isolation
* Release engineering
* Multi-platform deployment strategies
* Operational architecture
* DevOps engineering practices

The primary goal is not just building a Django application.

The primary goal is to understand how real enterprise deployment systems are structured, governed, versioned, deployed, rolled back, and managed.

The project intentionally supports multiple Azure deployment models using the same Django application.

---

# Core Application

The core application is a Django-based web application built using `uv`.

The application itself is intentionally simple because the focus of the project is deployment engineering and operational architecture.

Initial application features:

* Django project
* Multiple Django apps
* Username/password authentication
* Login page
* Protected homepage
* Database support
* Health endpoint

---

# Technology Stack

## Core Technologies

* Python
* Django
* uv
* PostgreSQL
* GitHub
* GitHub Actions
* Terraform
* Azure

---

# Supported Azure Deployment Models

The same Django application will support multiple deployment targets.

## Deployment Types

| Deployment Type          | Short Name |
| ------------------------ | ---------- |
| Azure App Service        | aas        |
| Azure Container Apps     | aca        |
| Azure Kubernetes Service | aks        |
| Azure Virtual Machine    | avm        |

These short names will be used consistently throughout the project.

Examples:

* folder names
* environment files
* deployment settings
* versioning
* pipelines
* Git tags
* deployment references

---

# Environment Strategy

The project supports four environments.

| Environment | Purpose                              |
| ----------- | ------------------------------------ |
| sandbox     | Personal experimentation environment |
| dev         | Development environment              |
| qa          | QA/testing environment               |
| prod        | Production environment               |

---

# Sandbox Environment Philosophy

Sandbox is a special environment.

Sandbox characteristics:

* manually triggered from laptop
* personal experimentation area
* still deploys into Azure cloud
* isolated from normal enterprise deployment flow
* used for learning and testing
* temporary playground environment

Sandbox behaves like a cloud-based local experimentation environment.

---

# High-Level Deployment Philosophy

The project is intentionally designed around:

* deployment isolation
* environment isolation
* rollback capability
* release traceability
* manual governance
* infrastructure reproducibility
* enterprise-style deployment control

The project does not assume:

* one deployment model
* one environment strategy
* one deployment tool
* automatic environment promotion

The project intentionally simulates real-world operational complexity.

---

# Repository Structure

```text
project/
├── app/
├── config/
├── deployment/
├── pyproject.toml
└── .github/
```

---

# Deployment Structure

Each deployment type owns its own deployment lifecycle.

```text
deployment/
  aas/
    terraform/
      modules/
    env/
      sandbox/
      dev/
      qa/
      prod/

  aca/
    terraform/
      modules/
    env/
      sandbox/
      dev/
      qa/
      prod/

  aks/
    terraform/
      modules/
    env/
      sandbox/
      dev/
      qa/
      prod/

  avm/
    terraform/
      modules/
    env/
      sandbox/
      dev/
      qa/
      prod/
    ansible/
```

---

# Deployment Structure Philosophy

Each deployment type owns:

* its Terraform modules
* its environment configurations
* its deployment lifecycle
* its deployment versions
* its deployment logic
* its operational tooling

The architecture intentionally avoids forcing all deployment types into a single generic model.

Different deployment targets may require different operational tools.

Examples:

| Deployment Type | Possible Tools             |
| --------------- | -------------------------- |
| aas             | Terraform                  |
| aca             | Terraform                  |
| aks             | Terraform + Helm + kubectl |
| avm             | Terraform + Ansible        |

The project philosophy is:

> Use the correct tool for the correct responsibility.

---

# Terraform Philosophy

Terraform is the foundation of infrastructure management.

Terraform responsibilities include:

* resource groups
* networking
* compute
* app services
* container services
* virtual machines
* kubernetes clusters
* PostgreSQL
* monitoring resources
* environment infrastructure

Terraform structure:

* reusable modules
* environment-specific configuration
* deployment isolation
* deployment-specific ownership

---

# Terraform Modules

Each deployment type contains reusable Terraform modules.

Examples:

```text
deployment/aas/terraform/modules/
deployment/aca/terraform/modules/
deployment/aks/terraform/modules/
deployment/avm/terraform/modules/
```

Modules may include:

* resource groups
* networking
* app services
* container apps
* virtual machines
* kubernetes clusters
* storage
* monitoring
* identity resources

---

# Environment Isolation Philosophy

Each environment is independent.

This means:

* dev can deploy independently
* qa can deploy independently
* prod can deploy independently
* rollback can happen independently
* environments do not depend on each other

The system intentionally avoids strict sequential promotion.

Example:

* prod can rollback without touching qa
* qa can test different versions
* dev can move ahead independently

The DevOps engineer decides:

* which version to deploy
* which environment to deploy
* when to deploy

---

# Django Settings Architecture

The Django application supports deployment-specific settings separation.

## Settings Structure

```text
config/
  settings_base.py
  settings_local.py
  settings_deploy_aas.py
  settings_deploy_aca.py
  settings_deploy_aks.py
  settings_deploy_avm.py
```

---

# Settings Philosophy

The project uses:

* base settings
* deployment-specific overrides

The goal is:

* minimal duplication
* deployment isolation
* deployment-specific customization
* clean maintainability

---

# Deployment Type Loader

Deployment-specific settings are loaded dynamically.

Example concept:

```python
DEPLOYMENT_TYPE = os.getenv("DEPLOYMENT_TYPE")
```

Then:

```python
if DEPLOYMENT_TYPE == "aas":
    load aas settings
elif DEPLOYMENT_TYPE == "aca":
    load aca settings
elif DEPLOYMENT_TYPE == "aks":
    load aks settings
elif DEPLOYMENT_TYPE == "avm":
    load avm settings
```

This allows:

* shared application logic
* deployment-specific configuration
* environment-specific overrides
* clean operational separation

---

# Environment File Naming Convention

Environment files follow strict naming standards.

## Environment File Examples

```text
.env.aas.sandbox
.env.aas.dev
.env.aas.qa
.env.aas.prod

.env.aca.sandbox
.env.aca.dev
.env.aca.qa
.env.aca.prod

.env.aks.sandbox
.env.aks.dev
.env.aks.qa
.env.aks.prod

.env.avm.sandbox
.env.avm.dev
.env.avm.qa
.env.avm.prod
```

This creates predictable operational behavior.

---

# Deployment Versioning Philosophy

The project separates:

* application version
* deployment version

This is a major architectural decision.

Reason:

Infrastructure may change independently from application code.

Each deployment type owns its own deployment version.

---

# Deployment Version Structure

Deployment versions are stored inside `pyproject.toml`.

Example:

```toml
[version.deployment]
aas = "0.1.0"
aca = "0.1.0"
aks = "0.1.0"
avm = "0.1.0"
```

---

# Deployment Change Detection

After Pull Request merge:

The pipeline detects:

* which folders changed
* which deployment type changed

Only the affected deployment version is incremented.

Example:

If only:

```text
deployment/aks/
```

changes,

then only:

```text
version.deployment.aks
```

is incremented.

Other deployment versions remain unchanged.

---

# GitHub Tagging Strategy

After deployment version increment:

GitHub tags are automatically created.

Examples:

```text
deploy-aas-v0.1.0
deploy-aca-v0.1.0
deploy-aks-v0.1.0
deploy-avm-v0.1.0
```

These tags represent deployment releases.

---

# Environment Version Mapping

Each environment references a selected deployment version.

Example concept:

```text
dev  -> aas 1.0.4
qa   -> aas 1.0.2
prod -> aas 1.0.1
```

This means:

* environments are independent
* production does not automatically use latest version
* rollback becomes easier
* testing becomes isolated

---

# Rollback Philosophy

Rollback is achieved by changing environment deployment versions.

Example:

Current production:

```text
aas 1.0.5
```

Rollback target:

```text
aas 1.0.4
```

Then deployment runs again.

Rollback does not require rebuilding artifacts.

This provides:

* safer releases
* operational stability
* predictable recovery

---

# Pull Request Pipeline Philosophy

When a Pull Request is created:

Terraform plan automatically runs.

The plan:

* detects changed deployment areas
* runs only for affected deployment types
* publishes plan output in Pull Request
* executes plans in parallel

Example:

```text
aas/dev plan
aas/qa plan
aas/prod plan
```

All plans may run simultaneously.

---

# Terraform Apply Philosophy

Terraform apply is manually controlled.

Characteristics:

* manually triggered
* deployment-specific
* environment-specific
* approval-based

Example:

A DevOps engineer may choose:

```text
Apply aas version 1.2.0 to qa only
```

or:

```text
Rollback prod to aas version 1.1.5
```

---

# Deployment Governance Philosophy

The project intentionally supports:

* manual deployment approval
* environment isolation
* operational governance
* deployment traceability
* controlled rollout
* rollback capability

The system intentionally avoids:

* forced sequential promotion
* uncontrolled automatic deployment
* tightly coupled environment dependencies

---

# Destroy Pipeline Philosophy

The project contains a separate destroy workflow.

Destroy operations are never automatic.

Destroy characteristics:

* manually triggered
* approval required
* deployment-specific
* environment-specific

Examples:

```text
Destroy aks sandbox
Destroy avm dev
```

Destroy pipeline executes:

```text
terraform plan -destroy
terraform destroy
```

only after approval.

---

# AVM Configuration Philosophy

Azure Virtual Machines may require additional configuration tools.

Terraform is responsible for:

* VM creation
* networking
* disks
* infrastructure

Ansible may be responsible for:

* OS configuration
* Python installation
* nginx configuration
* gunicorn setup
* application deployment
* server hardening

The project intentionally remains flexible.

The philosophy is:

> Use the correct tool for the correct responsibility.

---

# AKS Configuration Philosophy

AKS may require additional Kubernetes tooling.

Terraform responsibilities:

* cluster creation
* networking
* node pools
* infrastructure

Kubernetes/Helm responsibilities:

* application deployment
* ingress
* services
* autoscaling
* secrets
* operational configuration

---

# Azure App Service Philosophy

Azure App Service is expected to be the first and most difficult deployment target.

Reason:

It establishes:

* deployment structure
* settings structure
* environment conventions
* versioning strategy
* GitHub Actions patterns
* rollback model
* Terraform architecture
* deployment governance

Once Azure App Service is completed:

Subsequent deployment models become easier because:

* the operational foundation already exists
* pipelines already exist
* versioning already exists
* governance already exists
* naming conventions already exist

Future deployments primarily focus on service-specific behavior.

---

# Monitoring and Observability Strategy

Monitoring is a mandatory part of this project.

After every deployment type is created, the deployed service should be observable through Grafana.

The goal is not only to deploy the application, but also to understand whether the deployed application is healthy, reachable, stable, and performing correctly.

---

# Monitoring Philosophy

Monitoring will be treated as a shared foundation capability.

The first implementation will take more effort because the monitoring pattern needs to be established.

After the first monitoring setup is complete, the same pattern can be reused for other deployment types.

Monitoring should cover:

* application health
* service availability
* request/response behavior
* error visibility
* infrastructure metrics
* logs
* basic alerts
* deployment validation

---

# Grafana Role

Grafana will be used as the main visualization layer.

Grafana will show dashboards for:

* Azure App Service
* Azure Container Apps
* Azure Virtual Machines
* Azure Kubernetes Service

The dashboard structure should remain consistent across deployment types as much as possible.

Example dashboard areas:

* service uptime
* HTTP request count
* HTTP error count
* response time
* CPU usage
* memory usage
* instance/container/pod health
* deployment version
* environment name

---

# Monitoring Per Deployment Type

Each deployment type may need a different monitoring integration approach.

| Deployment Type | Monitoring Approach                                                |
| --------------- | ------------------------------------------------------------------ |
| aas             | Azure metrics + application logs + Grafana dashboard               |
| aca             | container metrics + logs + Grafana dashboard                       |
| avm             | VM metrics + app logs + possible node exporter + Grafana dashboard |
| aks             | Kubernetes metrics + pod logs + Prometheus/Grafana dashboard       |

The project remains flexible.

The monitoring toolchain may include:

* Grafana
* Prometheus
* Azure Monitor
* Log Analytics
* Loki
* node exporter
* Kubernetes metrics

The exact tool depends on the deployment type.

---

# Monitoring as One-Time Foundation Effort

The first monitoring setup will take the most time.

It will define:

* dashboard pattern
* naming convention
* labels/tags
* environment mapping
* service mapping
* log structure
* health check visibility
* alert pattern

After this foundation is established, each new deployment type only needs to plug into the same monitoring model.

---

# Monitoring Naming Convention

Grafana dashboards should clearly identify:

* deployment type
* environment
* service name
* version

Example dashboard names:

```text
aas-sandbox-django-dashboard
aas-dev-django-dashboard
aas-qa-django-dashboard
aas-prod-django-dashboard

aca-dev-django-dashboard
aks-prod-django-dashboard
avm-sandbox-django-dashboard
```

---

# Monitoring and Rollback

Monitoring is also part of rollback decision-making.

After deployment, the system should be checked using:

* health endpoint
* Grafana dashboard
* logs
* error rate
* response time

If production deployment fails or behaves badly, the environment version can be rolled back and redeployed.

Grafana helps confirm whether rollback restored the expected behavior.

---

# Operational Philosophy

The project intentionally simulates enterprise operational behavior.

Core principles:

* infrastructure reproducibility
* deployment governance
* release isolation
* rollback support
* environment independence
* operational traceability
* deployment-specific ownership
* controlled release engineering

The project is intentionally designed to resemble real-world platform engineering practices rather than simple tutorial-style deployments.

---

# Learning Objectives

This project aims to provide hands-on understanding of:

* Azure infrastructure
* Terraform architecture
* GitHub Actions
* deployment engineering
* rollback management
* release governance
* environment management
* operational engineering
* DevOps thinking
* infrastructure isolation
* enterprise deployment systems
* multi-platform deployment architecture

The project prioritizes operational architecture and deployment engineering over business functionality.
