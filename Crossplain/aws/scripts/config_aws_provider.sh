#!/usr/bin/env bash
set -euo pipefail

# Spit aws creds to a temp file
echo "[default]
aws_access_key_id = $(aws configure get aws_access_key_id)
aws_secret_access_key = $(aws configure get aws_secret_access_key)
" > aws-creds.conf

# To store the credentials as a secret,
# retrieve profile's credentials, save it under 'default' profile, and base64 encode it
BASE64ENCODED_AWS_ACCOUNT_CREDS=$(echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $aws_profile)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $aws_profile)" | base64  | tr -d "\n")


# create the Crossplane AWS Provider secret from temp file
kubectl create secret generic aws-creds -n crossplane-system \
  --from-file=creds=./aws-creds.conf

# rm creds.conf # delete temp file

# Install the crossplane aws provider
echo "Setting up AWS provider"
kubectl crossplane install provider crossplane/provider-aws:v0.22.0
# # Or via aws_provider.yaml
# kubectl apply -f config/aws_provider.yaml
# kubectl wait -f config/aws_provider.yaml --for condition=HEALTHY=True --timeout 1m

# Create a ProviderConfig:
kubectl apply -f ../config/aws_provider_config.yaml
