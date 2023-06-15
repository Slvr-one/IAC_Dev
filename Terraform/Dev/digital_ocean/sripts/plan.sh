#!/bin/bash
set -euo pipefail

pushd tf/

terraform plan \
    -var "do_token=$DO_PAT" \
    -var "pvt_key=/home/dvir/.ssh/id_rsa_do-1" \
    -var "pub_key=/home/dvir/.ssh/id_rsa_do-1.pub"

popd