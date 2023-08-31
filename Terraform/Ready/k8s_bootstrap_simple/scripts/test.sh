#!/usr/bin/env bash

set -eu

curl -fsSL \
  https://raw.githubusercontent.com/Slvr-one/IAC_Dev/main/Terraform/Ready/k8s_bootstrap_simple/scripts/tasker.sh \
  | /bin/sh -s -- run_test