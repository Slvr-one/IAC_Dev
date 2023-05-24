#!/bin/bash
set -euo pipefail

# install flux:
`shell flux --version 2>/dev/null` || curl \
  -s https://fluxcd.io/install.sh | sudo bash

# install crossplane cli:
`shell kubectl crossplane --version 2>/dev/null` || curl \
  -sL https://raw.githubusercontent.com/crossplane/crossplane/release-1.5/install.sh | sh

echo "Setting up AWS provider"
kubectl apply -f aws-provider.yaml
kubectl wait -f aws-provider.yaml --for condition=HEALTHY=True --timeout 1m
./generate-aws-secret.sh

