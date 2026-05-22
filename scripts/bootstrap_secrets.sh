#!/bin/bash
set -e

# --- Django secret keys ---
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

# --- GitHub Environments ---
REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
USER_ID=$(gh api /user --jq '.id')
USERNAME=$(gh api /user --jq '.login')

for ENV in dev qa prod; do
  echo "Setting up GitHub environment: $ENV"
  gh api \
    --method PUT \
    "/repos/${REPO}/environments/${ENV}" \
    --input - <<EOF
{
  "reviewers": [{"type": "User", "id": ${USER_ID}}]
}
EOF
  echo "Environment '$ENV' created with required reviewer: $USERNAME"
done
