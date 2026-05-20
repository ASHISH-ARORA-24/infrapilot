#!/bin/bash
set -e

for ENV in DEV QA PROD; do
  SECRET_NAME="TF_VAR_DJANGO_SECRET_KEY_AAS_${ENV}"
  if ! gh secret list | grep -q "^${SECRET_NAME}"; then
    SECRET_VALUE=$(python3 -c "import secrets; print(secrets.token_urlsafe(50))")
    gh secret set "$SECRET_NAME" --body "$SECRET_VALUE"
    echo "Created $SECRET_NAME"
  else
    echo "$SECRET_NAME already exists, skipping"
  fi
done
