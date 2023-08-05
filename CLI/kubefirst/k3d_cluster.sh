#!/usr/env/bin bash
set -euxE


cluster_name="victor"


kubefirst k3d create \
  --cluster-name $cluster_name