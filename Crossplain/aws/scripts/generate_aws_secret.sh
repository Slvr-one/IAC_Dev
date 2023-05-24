#!/usr/bin/env bash

set -euo pipefail

# AWS_PROFILE=default 
# echo -e "[default]\naws_access_key_id = \
#   $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = \
#   $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > aws-creds.conf

echo "[default]
aws_access_key_id = $(aws configure get aws_access_key_id)
aws_secret_access_key = $(aws configure get aws_secret_access_key)
" > aws-creds.conf

# create the Crossplane AWS Provider secret
kubectl create secret generic aws-creds -n crossplane-system \
  --from-file=creds=./aws-creds.conf

# rm creds.conf

# Install the crossplane aws provider
kubectl crossplane install provider crossplane/provider-aws:v0.22.0

# # Or via aws_provider.yaml
# kubectl apply -f crossplane_config/provider-aws.yaml
